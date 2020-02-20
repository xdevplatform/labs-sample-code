require "net/https"
require "uri"
require 'base64'
require 'json'
require 'dotenv/load'

@query = '(Twitter Labs search) OR from:TwitterDev OR from:SnowBotDev OR from:DailyNASA'
@max_requests = 3

SEARCH_URL = "https://api.twitter.com/labs/1/tweets/search"

def make_request(bearer_token, query)

  uri = URI(SEARCH_URL)

  options = {}
  options['query'] = query
  options['max_results'] = 10
 
  uri.query = URI.encode_www_form(options)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  request['Authorization'] = "Bearer #{bearer_token}"
  request['User-Agent'] = "RecentSearchQuickStartRuby"

  response = http.request(request)

  return response
end

if __FILE__ == $0  #This script code is executed when running this file.

  bearer_token = ENV['TWITTER_BEARER_TOKEN']

  request_count = 0
  tweet_count = 0

  loop do
    request_count += 1
    response = make_request(bearer_token, @query)
    response_json = JSON.parse(response.body)
    puts JSON.pretty_generate(response_json)

    next_token = response_json['meta']['next_token']
    tweet_count += response_json['meta']['result_count'].to_i

    break if next_token.nil? or request_count == @max_requests
  end

  puts "Made #{request_count} requests and received #{tweet_count} Tweets."

end
