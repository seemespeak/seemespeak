require File.expand_path('../../config/environment', __FILE__)
require 'json'
require 'fileutils'

if (ARGV.length != 2)
  puts "Usage: dgs_importer.rb <path to the dgs files (where dgs_import was executed)> <target path (as in video_conversion.yml)>"
  exit
end

path = ARGV[0]

Dir.glob(File.join(path, "*.json")).each do |file|
  file_base = file
  file_base = File.basename(file_base, ".*") until File.extname(file_base).empty?
  mp4_file = File.join(path, "#{file_base}.mp4")
  flv_file = File.join(path, "#{file_base}.flv")

  json = JSON.parse( IO.read(file) )

  if (File.exist?(mp4_file))
    puts "#{ json["word"]} : Indexing existing mp4, jpg, webm"
    entry = Entry.new(transcription: json["word"],
              reviewed: true,
              language: "DGS",
              video: Video.new(converted: true),
              copyright: Copyright.new(author: "DGS Wiki - #{json["author"]}",
                                       link: json["word_link"]),
              tags: json["tags"])
    entry.index

    target_path = File.join(ARGV[1], "entry_#{entry.id}")
    FileUtils.mkdir_p(target_path)

    begin
      FileUtils.cp(mp4_file,
                   File.join(target_path, "movie.mp4"))
      FileUtils.cp(File.join(path, "#{file_base}.webm"),
                   File.join(target_path, "movie.webm"))
      FileUtils.cp(File.join(path, "#{file_base}.jpg"),
                   File.join(target_path, "picture.jpg"))
    rescue Exception => e
      "Warning: #{e}"
    end
  elsif (File.exists?(flv_file))
    puts "#{json["word"]} : Indexing and transcoding entry"
    entry = Entry.new(transcription: json["word"],
              reviewed: true,
              language: "DGS",
              video: Video.new(converted: false),
              copyright: Copyright.new(author: "DGS Wiki - #{json["author"]}",
                                       link: json["word_link"]),
              tags: json["tags"])
    entry.index
    VideosController.new.transcode_entry(entry.id, flv_file)
  else
    puts "File not found: #{mp4_file}"
  end

end
