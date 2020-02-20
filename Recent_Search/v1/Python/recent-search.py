import json
import os
import urllib.parse
import requests
from requests.auth import AuthBase

from dotenv import load_dotenv
load_dotenv(verbose=True)  # Throws error if it can't find .env file

# Retrieves credential information from the '.env' file
BEARER_TOKEN = os.getenv("TWITTER_BEARER_TOKEN")

SEARCH_URL = "https://api.twitter.com/labs/1/tweets/search"
QUERY = "(snow OR hail OR rain) (Colorado OR #COWX) has:images"
MAX_REQUESTS = 3
OPTIONS = "&format=compact" #Labs v1 only.

def get_tweets(auth, query):

    url = f"{SEARCH_URL}?query={QUERY}{OPTIONS}" #{urllib.parse.quote(REQUEST_PARAMETERS)}"
    response = requests.get(url, auth=auth, headers = headers)

    if response.status_code is not 200:
        #raise Exception(f"Error with request (HTTP error code: {response.status_code} - {response.reason}")
        print (f"Error with request (HTTP error code: {response.status_code} - {response.reason}")

    return response
    
#-----------------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":

  query = urllib.parse.quote(QUERY)
  bearer_token = BEARER_TOKEN

  #As we page through results, we will be counting these: 
  request_count = 0
  tweet_count = 0

  while True:
      #loop body
      request_count += 1
      response = get_tweets(bearer_token, query)
      parsed = json.loads(response.text)
      print (json.dumps(parsed, indent=2, sort_keys=True))

      try:
          next_token  = parsed['meta']['next_token']
      except KeyError:
          next_token = None

      try:
          tweet_count  += parsed['meta']['result_count']
      except KeyError:
          pass

      if (next_token is None or request_count == MAX_REQUESTS): break

  print(f"Made {request_count} requests and received {tweet_count} Tweets...")
