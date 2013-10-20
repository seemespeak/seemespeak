require File.expand_path('../../config/environment', __FILE__)
require 'json'
require 'fileutils'

if (ARGV.length != 2)
  puts "Please add the path to the dgs files and the target path as param"
  exit
end

path = ARGV[0]

Dir.glob(File.join(path, "json", "*.json")).each do |file|
  file_base = File.basename(file, ".*")
  mp4_file = File.join(path, "mp4", "#{file_base}.mp4")
  if (File.exist?(mp4_file))
    json = JSON.parse( IO.read(file) )
    puts json["word"]

    entry = Entry.new(transcription: json["word"],
              reviewed: true,
              language: "DGS",
              video: Video.new(converted: true),
              copyright: Copyright.new(author: "DGS Wiki - #{json["author"]}",
                                       link: json["word_link"]))
    entry.index

    target_path = File.join(ARGV[1], "entry_#{entry.id}")
    FileUtils.mkdir_p(target_path)

    FileUtils.cp(mp4_file,
                 File.join(target_path, "movie.mp4"))
    FileUtils.cp(File.join(path, "webm", "#{file_base}.webm"),
                 File.join(target_path, "movie.webm"))
    FileUtils.cp(File.join(path, "jpg", "#{file_base}.jpg"),
                 File.join(target_path, "picture.jpg"))
  end

end
