from requests_oauthlib import OAuth1Session
import os
import json

# Auth
consumer_key = os.environ.get("CONSUMER_KEY")
consumer_secret = os.environ.get("CONSUMER_SECRET")

request_token_url = "https://api.twitter.com/oauth/request_token"
oauth = OAuth1Session(consumer_key, client_secret=consumer_secret)
fetch_response = oauth.fetch_request_token(request_token_url)
resource_owner_key = fetch_response.get("oauth_token")
resource_owner_secret = fetch_response.get("oauth_token_secret")
print("Got OAuth token: {}".format(resource_owner_key))

# Get authorization
base_authorization_url = "https://api.twitter.com/oauth/authorize"
authorization_url = oauth.authorization_url(base_authorization_url)
print("Please go here and authorize: {}".format(authorization_url))
verifier = input("Paste the PIN here: ")

# Get the access token
access_token_url = "https://api.twitter.com/oauth/access_token"
oauth = OAuth1Session(
    consumer_key,
    client_secret=consumer_secret,
    resource_owner_key=resource_owner_key,
    resource_owner_secret=resource_owner_secret,
    verifier=verifier,
)
oauth_tokens = oauth.fetch_access_token(access_token_url)

access_token = oauth_tokens["oauth_token"]
access_token_secret = oauth_tokens["oauth_token_secret"]

# Make the request
oauth = OAuth1Session(
    consumer_key,
    client_secret=consumer_secret,
    resource_owner_key=access_token,
    resource_owner_secret=access_token_secret,
)

# Get handle to look up
handle = input("What username do you want to look up?\n")
params = {"usernames": "{}".format(handle)}

response = oauth.get("https://api.twitter.com/labs/1/users", params=params)

# Turn response into JSON
if response.encoding is None:
    response.encoding = "utf-8"
for data in response.iter_lines(decode_unicode=True):
    if data:
        jdata = json.loads(data)

# Print out information
print("Bio: ")
print(jdata["data"][0]["description"])
print("Location: ")
print(jdata["data"][0]["location"])
