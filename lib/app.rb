require 'sinatra'
require "rss"

require './lib/scrapper'

get '/feed.xml' do
  entries = Scrapper.fetch!

  content_type 'text/xml'

  RSS::Maker.make("2.0") do |maker|
    author = "Tom Yelland"
    email = "tomyelland1@gmail.com"
    explicit = false
    image = "https://s3.amazonaws.com/flowfeeds/tom_yelland_the_journey.jpg"
    keywords = %w(tom yelland electronic dance trance)
    title = "The Journey"
    new_feed_url = "http://tom-yelland.herokuapp.com/feed.xml"
    subtitle = "Sunshine House Music"
    description = "The best in Soulful, funky & vocal house with a touch of Garage thrown in for good measure. Podcasts released 1st of every month."
    website = "http://tomyelland.isoterra.co.uk/"

    maker.channel.title = title
    maker.channel.link = website
    maker.channel.description = description
    maker.channel.about = subtitle
    maker.channel.author = author
    maker.channel.updated = Time.now.to_s

    maker.channel.itunes_author = author
    maker.channel.itunes_categories.new_category.text = "Music"
    maker.channel.itunes_image = image
    maker.channel.itunes_explicit = explicit
    maker.channel.itunes_keywords = keywords
    maker.channel.itunes_new_feed_url = new_feed_url
    maker.channel.itunes_owner.itunes_name = author
    maker.channel.itunes_owner.itunes_email = email
    maker.channel.itunes_subtitle = subtitle
    maker.channel.itunes_summary = description

    entries.each do |entry|
      maker.items.new_item do |item|
        item.title = entry[:title]
        item.link = entry[:url]
        item.guid.content = entry[:url]
        item.guid.isPermaLink = true
        item.author = author
        item.description = entry[:description]
        item.pubDate = entry[:published]

        item.itunes_author = author
        item.itunes_keywords = keywords
        item.itunes_explicit = explicit
        item.itunes_subtitle = entry[:description]
        item.itunes_summary = entry[:description]

        item.enclosure.url = entry[:url]
        item.enclosure.length = 0
        item.enclosure.type = 'audio/mpeg'
      end
    end
  end.to_s
end
