require 'oauth'
require 'yaml'

@consumer_key = # Add your API key here
@consumer_secret = # Add your API secret key here

@consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret,
                                :site => 'https://api.twitter.com',
                                :authorize_path => '/oauth/authenticate',
                                :debug_output => false)                                

@request_token = @consumer.get_request_token()

@token = @request_token.token
@token_secret = @request_token.secret
puts "Authorize via this URL: #{@request_token.authorize_url()}"
puts "Enter PIN: "
@pin = gets.strip

@hash = { :oauth_token => @token, :oauth_token_secret => @token_secret}
@request_token  = OAuth::RequestToken.from_hash(@consumer, @hash)
@access_token = @request_token.get_access_token({:oauth_verifier => @pin})

require 'typhoeus'
require 'oauth/request_proxy/typhoeus_request'

@uri = "https://api.twitter.com/labs/1/tweets?ids=1067094924124872705&format=detailed"
@options = {
    :method => :get,
    :headers => { 
        "x-des-apiservices" => "staging2"
     }
}

@oauth_params = {:consumer => @consumer, :token => @access_token}
@hydra = Typhoeus::Hydra.new
@req = Typhoeus::Request.new(@uri, @options) # :method needs to be specified in options
@oauth_helper = OAuth::Client::Helper.new(@req, @oauth_params.merge(:request_uri => @uri))
@req.options[:headers].merge!({"Authorization" => @oauth_helper.header}) # Signs the request
@hydra.queue(@req)
@hydra.run
@response = @req.response

puts @response.body
