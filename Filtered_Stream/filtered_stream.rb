require 'typhoeus'
require 'base64'
require 'json'

@consumer_key = "" # Add your API key here
@consumer_secret = "" # Add your API secret key here

@bearer_token_url = "https://api.twitter.com/oauth2/token"
@stream_url = "https://api.twitter.com/labs/1/tweets/stream/filter"
@rules_url = "https://api.twitter.com/labs/1/tweets/stream/filter/rules"

@sample_rules = [
  { 'value': 'dog has:images', 'tag': 'dog pictures' },
  { 'value': 'cat has:images -grumpy', 'tag': 'cat pictures' },
]

def bearer_token
  return @bearer_token unless @bearer_token.nil?

  @credentials = Base64.encode64("#{@consumer_key}:#{@consumer_secret}").gsub("\n", "")
  
  @options = {
    body: {
      grant_type: "client_credentials"
    },
    headers: {
      "Authorization": "Basic #{@credentials}",
      "User-Agent": "TwitterDevFilteredStreamQuickStartRuby"
    }
  }

  @response = Typhoeus.post(@bearer_token_url, @options)
  @body = JSON.parse(@response.body)
  @bearer_token = @body["access_token"] ||= nil
end

def get_all_rules
  @options = {
    headers: {
      "User-Agent": "TwitterDevFilteredStreamQuickStartRuby"
      "Authorization": "Bearer #{bearer_token}"
    }
  }

  @response = Typhoeus.get(@rules_url, @options)

  raise "An error occurred while getting a list of rules: #{@response.body}" unless @response.success?

  @body = JSON.parse(@response.body)
end

def delete_all_rules(rules)
  return if rules.nil?

  @ids = rules['data'].map { |rule| rule["id"] }
  @payload = {
    delete: {
      ids: @ids
    }
  }

  @options = {
    headers: {
      "User-Agent": "TwitterDevFilteredStreamQuickStartRuby"
      "Authorization": "Bearer #{bearer_token}",
      "Content-type": "application/json"
    },
    body: JSON.dump(@payload)
  }

  @response = Typhoeus.post(@rules_url, @options)

  raise "An error occurred while deleting your rules: #{@response.status_message}" unless @response.success?
end

def set_rules(rules)
  return if rules.nil?

  @payload = {
    add: rules
  }

  @options = {
    headers: {
      "User-Agent": "TwitterDevFilteredStreamQuickStartRuby"
      "Authorization": "Bearer #{bearer_token}",
      "Content-type": "application/json"
    },
    body: JSON.dump(@payload)
  }

  @response = Typhoeus.post(@rules_url, @options)
  raise "An error occurred while adding rules: #{@response.status_message}" unless @response.success?
end

def stream_connect
  @options = {
    timeout: 20,
    method: 'get',
    headers: {
      "User-Agent": "TwitterDevFilteredStreamQuickStartRuby"
      "Authorization": "Bearer #{bearer_token}",
    },
    params: {
      format: 'compact'
    }
  }

  @request = Typhoeus::Request.new(@stream_url, @options)
  @request.on_body do |chunk|
    puts chunk
  end
  @request.run
end

def setup_rules
  # Gets the complete list of rules currently applied to the stream
  @rules = get_all_rules

  # Delete all rules
  delete_all_rules(@rules)
  
  # Add rules to the stream
  set_rules(@sample_rules)
end


# Comment this line if you already setup rules and want to keep them
setup_rules

# Listen to the stream.
# This reconnection logic will attempt to reconnect when a disconnection is detected.
# To avoid rate limites, this logic implements exponential backoff, so the wait time
# will increase if the client cannot reconnect to the stream.
timeout = 0
while true
  stream_connect
  sleep 2 ** timeout
  timeout += 1
end