# This is a small script that generates 
# a csv file with data and grabs the
# movie from the wiki sign project.
#
# These files can be imported using the
# dgs_importer script.
#
# Not very perfect, but it does the trick.
#
# ToDo: detect changes in the wiki and
# create a diff for this
require 'nokogiri'
require 'open-uri'
require 'json'

module Dgs
  class Crawler
    def initialize(target_path)
      @target_path = File.join Dir.pwd, target_path
    end

    def get_description(main, url, result)
      doc = Nokogiri::HTML.parse(open(main + url))

      link = doc.css(".mw-imagepage-linkstoimage li a").first
      if (link)
        result[:word] = link.text
        result[:word_link] = main + link.attribute("href").value
      end

      author = doc.css(".mw-userlink")
      if (author)
        result[:author] = author.text
        result[:author_link] = main + author.attribute("href").value
      end

      result[:tags] = []
      doc.css(".mw-imagepage-linkstoimage li a").each do |page|
        details = get_details_from_word(main, page.attribute("href"))
        result[:tags].concat(details[:tags])
      end

      filename = url.split("Datei:").last
      File.open(File.join(@target_path, filename + ".json"), 'w') do |file|
        file.write(result.to_json)
      end
    end

    def get_details_from_word(main, url)
      result = {tags: []}
      doc = Nokogiri::HTML.parse(open(main + url))
      doc.css("#catlinks a").each do |link|
        cat = link.attribute("href").value.match(/\/wiki\/Kategorie:(.*)/)
        if (cat)
          result[:tags] << cat[1]
        end
      end
      result
    end

    def download_page(main, url)
      doc = Nokogiri::HTML.parse(open(main + url))
      description = {}

      doc.css(".TablePager_col_img_name a").each do |link|
        href = link.attr("href")
        hrefd = href.downcase
        if hrefd.match(/\/upload.*\.flv/) ||
           hrefd.match(/\/upload.*\.mov/) ||
           hrefd.match(/\/upload.*\.mp4/)
          description['video_link'] = main + href
        end
        if hrefd.match(/\/wiki\/.*\.flv/) ||
           hrefd.match(/\/wiki\/.*\.mov/) ||
           hrefd.match(/\/wiki\/.*\.mp4/)
          puts href
          get_description(main, href, description)
        end
      end

      doc.css(".mw-nextlink").attr("href")
    end

    def download_all
      link = "/wiki/Spezial:Dateien"
      while (link)
        link = download_page("http://dgs.wikisign.org", link)
      end
    end
  end
end

if __FILE__ == $0
  if (ARGV.length != 1)
    puts "Usage: dgs_importer.rb <path to store json files with crawling results>"
    exit
  end

  Dgs::Crawler.new(ARGV[0]).download_all
end
