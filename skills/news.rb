require 'open-uri'
require 'json'
require 'dotenv'

Dotenv.load
# Class for finding the worldnews
class GenerateNews
  def receive_headlines
    news = Array.new
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
end
