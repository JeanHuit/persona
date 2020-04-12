require 'telegram_bot'
require 'dotenv'
require 'redis'
require_relative './skills/dictionary'

Dotenv.load

bot = TelegramBot.new(token: ENV['token'])

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  last_word = Redis.new(host: 'localhost')

  get_meaning = GenerateMeaning.new

  message.reply do |reply|
    case command
    when /start/i
      reply.text = "Hello, #{message.from.first_name}!"
    when /define/i
      last_word.set('comm', command)
      reply.text = 'What word do you want my help with?'
    when /stop/i
      reply.text = 'See you later'
    else
      case command
      when last_word.get('comm') == '/define' && command
        reply.text = get_meaning.meaning(command)
        last_word.set('comm', 'done')
      else
        reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means in this context, use: /help"
      end
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
