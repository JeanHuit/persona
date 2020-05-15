require 'open-uri'
require 'json'
require 'dotenv'
require 'rss'

Dotenv.load
# Class for finding the worldnews
class GenerateNews
  time_parameter = Time.now
  @time_ = time_parameter.year.to_s + '-' + time_parameter.month.to_s + '-' +
           time_parameter.day.to_s

  def newsapi
    news = []
    newsapi = ENV['news_key']
    url = "http://newsapi.org/v2/top-headlines?sources=google-news&apiKey=#{newsapi}"
    raw_output = URI.open(url).read
    content = JSON.parse(raw_output)
    totalresults = content['totalResults'].to_i
    (0...totalresults).each do |number|
      news << content['articles'][number]['title']
    end
    news.join("\n")
  end

  def rss_feed
    news_feed = Hash.new
    number = 0
    url = 'https://cdn.ghanaweb.com/feed/newsfeed.xml'
    feed = RSS::Parser.parse(URI.open(url).read)
    puts "Title: #{feed.channel.title}"
    feed.items.each do |item|
      news_feed[number] = item.title.to_s + "\n" + item.description.to_s + "\n" + item.link.to_s
      number += 1
    end
    news_feed[1]
  end
end
