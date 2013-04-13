require 'nokogiri'
require 'open-uri'
require 'chronic'

module Scrapper
  def self.fetch!
    entries = []

    base = "http://tomyelland.isoterra.co.uk"

    index = open(base).read
    index = index.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    index = index.chars.select { |i| i.valid_encoding? }.join

    html = Nokogiri::HTML(index)
    html.css("body > div.box").each do |box|
      download_link = box.css("a").select { |l| l['href'] =~ /\.mp3$/ }.first
      next unless download_link

      title = download_link.text
      url   = download_link['href']
      notes = box.css('.notes').text
      published = Chronic.parse(box.css("p").text.split("::").first.strip)

      entries << {
        title: title,
        url: "#{base}/#{url}",
        description: notes,
        published: published
      }
    end

    entries
  end
end
