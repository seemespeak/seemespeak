require 'active_support/concern'
require 'video_transcoder'
require 'fileutils'

module Concerns
  module Transcodable
    def transcode_entry(entry_id, file)
      Rails.logger.warn("Running Queue: #{entry_id} - #{file}")
      target_dir = File.join(VideoConversionSettings.video_path, "entry_#{entry_id}")
      entry = Entry.get(entry_id)

      FileUtils.mkdir_p(target_dir)

      transcoder = VideoTranscoder.new
      size = OpenStruct.new(width: 640, height: 480)

      success = transcoder.transcode(file, File.join(target_dir, "movie.mp4"), size)
      if (success)
        success = transcoder.transcode(file, File.join(target_dir, "movie.webm"), size)
      end

      Rails.logger.warn("Success ? #{success}")

      transcoder.create_picture(File.join(target_dir, "movie.mp4"), File.join(target_dir, "picture.jpg"), OpenStruct.new(width:400, height: 300))

      FileUtils.move(file, File.join(target_dir, "original.webm"))

      entry.video.converted = success
      entry.index
    end
  end
end
