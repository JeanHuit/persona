# This script sets up a chat bot using PersonalityForge.com Various existing bots are used here.

require 'open-uri'
require 'json'
require 'dotenv'

Dotenv.load

# Begin the chat, with a randomized selection of bots
class BeginConversation
  def choosebot
    arr = [71367, 63906, 147504, 6, 6526, 148149, 78951, 118099, 159151, 64022, 150647, 92626]
    arr[rand(11)]
  end

  def converse(chat)
    key = ENV['chat_key']
    url = "https://www.personalityforge.com/api/chat/?apiKey=#{key}&chatBotID=#{choosebot}&message=#{chat}&externalID=ntikuma07"
    content = JSON.parse(URI.open(url).string)
    content['message']['message']
  end
end
