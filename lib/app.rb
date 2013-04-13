require 'sinatra'
require "rss"

require './lib/scrapper'

get '/feed.xml' do
  entries = Scrapper.fetch!

  content_type 'text/xml'

  RSS::Maker.make("2.0") do |maker|
    maker.channel.title = "Tom Yelland"
    maker.channel.link = "http://tomyelland.isoterra.co.uk/"
    maker.channel.description = "Tom Yelland's Mixes"
    maker.channel.about = "Tom Yelland's Mixes"
    maker.channel.author = "Tom Yelland"
    maker.channel.updated = Time.now.to_s

    entries.each do |entry|
      maker.items.new_item do |item|
        item.title = entry[:title]
        item.link = entry[:url]
        item.description = entry[:description]

        item.guid.content = entry[:url]
        item.guid.isPermaLink = true

        item.pubDate = entry[:published]

        item.itunes_subtitle = ""
        item.itunes_explicit = "No"
        item.itunes_author = "Tom Yelland"

        item.enclosure.url = entry[:url]
        item.enclosure.length = 12345
        item.enclosure.type = 'audio/mpeg'
      end
    end
  end.to_s
end
