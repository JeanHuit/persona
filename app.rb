require 'telegram/bot'
require 'dotenv'
require 'redis'
require_relative './skills/dictionary'
require_relative './skills/news'
require 'net/http/persistent'

Dotenv.load

token = ENV['token']

Telegram::Bot.configure do |config|
  config.adapter = :net_http_persistent
end

last_word = Redis.new(host: 'localhost')
get_meaning = GenerateMeaning.new
worldheadlines = GenerateNews.new
rss_feed = GenerateNews.new

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/define'
      last_word.set('comm', message.text)
      bot.api.send_message(chat_id: message.chat.id, text: 'What word do you want my help with?')
    when '/headlines'
      bot.api.send_message(chat_id: message.chat.id, text: rss_feed.rss_feed)
    when '/worldheadlines'
      bot.api.send_message(chat_id: message.chat.id, text: worldheadlines.newsapi)
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    else
      case message.text
      when last_word.get('comm') == '/define' && message.text
        bot.api.send_message(chat_id: message.chat.id, text: get_meaning.meaning(message.text)) 
        last_word.set('comm', 'done')
      else
        bot.api.send_message(chat_id: message.chat.id, text: " have no idea what #{message.inspect} means in this context, use: /help")
      end
    end
  end
end
