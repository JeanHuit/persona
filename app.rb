require 'telegram_bot'
require 'dotenv'
require_relative './skills/dictionary'

Dotenv.load

bot = TelegramBot.new(token: ENV['token'])

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  get_meaning = GenerateMeaning.new

  message.reply do |reply|
    case command
    when /greet/i
      reply.text = "Hello, #{message.from.first_name}!"
    when /define/i
      reply.text = "What word do you want my help with?"
      # reply.text = get_meaning.meaning(message)
    else
      reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end

      # wprd= gets.chomp
      # get_meaning = GenerateMeaning.new
      # result = get_meaning.meaning(word)
      # bot.api.send_message(chat_id: message.chat.id, text: result.to_s)
