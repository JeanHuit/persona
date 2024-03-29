require 'open-uri'
require 'json'
require 'dotenv'
require 'rss'

Dotenv.load
class GenerateNews

  def rss_feed
    ness = []
    news_feed = []
    number = 0
    url = 'https://rss.modernghana.com/news.xml'
    #rescue RSS::NotAvailableValueError
    feed = RSS::Parser.parse(URI.open(url).read, validate: false)
    puts "Title: #{feed.channel.title}"
    feed.items.each do |item|
      news_feed[number] = '*' + item.title.to_s
      number += 1
    end
    if news_feed.join.length > 4096
      (0...25).each do |num|
        ness << news_feed[num]
      end
      ness.join("\n")
      (26...50).each do |num|
        ness << news_feed[num]
      end
      ness.join("\n")
    else
      news_feed.join("\n")
    end
  end
end
