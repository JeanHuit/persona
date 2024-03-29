require 'telegram/bot'
require 'dotenv'
require 'redis'
# require 'net/http/persistent'
require_relative './skills/dictionary'
require_relative './skills/news'
require_relative './skills/chat'
require_relative './skills/tax'


Dotenv.load

token = ENV['_TOKEN']

# Telegram::Bot.configure do |config|
#   config.adapter = :net_http_persistent
# end

last_word = Redis.new(url: ENV['REDIS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
get_meaning = GenerateMeaning.new
rss_feed = GenerateNews.new
talk = BeginConversation.new
get_tax = CalculateTax.new

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message&.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/define'
      last_word.set('comm', message.text)
      bot.api.send_message(chat_id: message.chat.id, text: 'What word do you want my help with?')
    when '/headlines'
      bot.api.send_message(chat_id: message.chat.id, text: rss_feed.rss_feed)
    when '/chat'
      last_word.set('comm', message.text)
      bot.api.send_message(chat_id: message.chat.id, text: 'Begin the Conversation, use "/stop" to end')
    when '/stop'
      last_word.set('comm', message.text)
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    when '/tax'
      last_word.set('comm', message.text)
      bot.api.send_message(chat_id: message.chat.id, text: "Whats the amount ?")
    when last_word.get('comm') == '/define' && message.text
      bot.api.send_message(chat_id: message.chat.id, text: get_meaning.meaning(message.text))
      last_word.set('comm', 'done')
    when last_word.get('comm') == '/tax'  && message.text
      bot.api.send_message(chat_id: message.chat.id, text: get_tax.calculate(message.text.to_i))
      last_word.set('comm', 'done')
    when last_word.get('comm') == '/chat' && message.text
      if message.text == '/stop'
        last_word.set('comm', message.text)
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
      else
        bot.api.send_message(chat_id: message.chat.id, text: talk.converse(message.text))
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: "This command does not exist")
    end
  end
end
