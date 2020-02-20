require "net/https"
require "uri"
require 'base64'
require 'json'

#Quote your Twitter App consumer keys here.
CONSUMER_KEY = "" # Add your API key here
CONSUMER_SECRET = "" # Add your API secret key here

@search_url = "https://api.twitter.com/labs/1/tweets/search"
query = '(Labs Search Twitter) OR from:TwitterDev OR from:SnowBotDev OR from:DailyNASA'

options = {"query" => query, "format" => 'compact'}

def bearer_token(consumer_key, consumer_secret)
# Generates a Bearer Token using your Twitter App's consumer key and secret.
# Calls the Twitter URL below and returns the Bearer Token.
  bearer_token_url = "https://api.twitter.com/oauth2/token"

  return @bearer_token unless @bearer_token.nil?

  credentials = Base64.encode64("#{consumer_key}:#{consumer_secret}").gsub("\n", "")

  uri = URI(bearer_token_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Post.new(uri.path)
  request.body =  "grant_type=client_credentials"
  request['Authorization'] = "Basic #{credentials}"
  request['User-Agent'] = "LabsRecentSearchQuickStartRuby"

  response = http.request(request)

  body = JSON.parse(response.body)

  body['access_token']

end

def make_request(key, secret, query)

  uri = URI(@search_url)

  options = {}
  options['query'] = query
  options['max_results'] = 10
  options['format'] = 'compact'
  #options['start_time'] = nil
  #options['end_time'] = nil

  uri.query = URI.encode_www_form(options)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  request['Authorization'] = "Bearer #{bearer_token(key,secret)}"
  request['User-Agent'] = "RecentSearchQuickStartRuby"

  response = http.request(request)

  return response
end

response = make_request(CONSUMER_KEY, CONSUMER_SECRET, query)

puts JSON.pretty_generate(JSON.parse(response.body))
