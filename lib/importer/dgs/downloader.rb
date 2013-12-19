require 'json'
require 'net/http'

module Dgs
  class Downloader
    def initialize(path)
      @path = File.absolute_path ARGV[0]
    end

    def json_files
      Dir.glob(File.join(@path, "*.json"))
    end

    def urls
      json_files
      .map { |f| JSON.parse(File.read(f)) }
      .map { |json| json['video_link'] }
      .compact
    end

    def file_name_for(url)
      File.basename(url.split("Datei:").last, ".*") + File.extname(url)
    end

    def download(url, file_name)
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port) do |http|
        resp = http.get(uri.request_uri)
        File.open(File.join(@path, file_name), "wb") do |file|
          file.write(resp.body)
        end
      end
      true
    end

    def download_if_exists(url, file_name)
      unless File.exist? File.join(@path, file_name)
        puts file_name
        download url, file_name
      end
    end

    def download_all
      urls.each do |url|
        file_name = 
        download_if_exists url, file_name_for(url)
      end
    end
  end
end

if __FILE__ == $0
  if (ARGV.length != 1)
    puts "Usage: dgs_importer.rb <path with crawling results, to store videos in>"
    exit
  end

  Dgs::Downloader.new(ARGV[0]).download_all
end
