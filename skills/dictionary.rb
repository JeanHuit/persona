require 'open-uri'
require 'json'
require 'dotenv'

Dotenv.load

# Class for finding the definition of words
class GenerateMeaning
  # Function to read url and parse output
  def meaning(word)
    key = ENV['owls_key']
    url = "https://owlbot.info/api/v4/dictionary/#{word.downcase}?format=json"
    raw_output = URI.open(url, 'Authorization' => "Token #{key}").read
    content = JSON.parse(raw_output)
    # Using rescue to catch errors that may pop up
  rescue NoMethodError
    puts 'bad word'
  rescue OpenURI::HTTPError
    puts 'word does not exist, please try another'
  else
    content
  end
end
