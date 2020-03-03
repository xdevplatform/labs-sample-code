library(httr)
library(jsonlite)
library(caTools)
library(dplyr)

# Replace the keys below from your Twitter app from https://developer.twitter.com/en/apps
api_key <- 'REPLACE_API_KEY'
api_secret <- 'REPLACE_API_SECRET'

encoded_keys <- base64encode(sprintf('%s:%s', api_key, api_secret))

access_token_request <-
  POST(url = 'https://api.twitter.com/oauth2/token',
       body = 'grant_type=client_credentials',
       add_headers
       (
         .headers = c(
           'Authorization' = sprintf('Basic %s', encoded_keys),
           'Content-Type' = 'application/x-www-form-urlencoded'
         )
       ))

access_token_body <- content(access_token_request, as = 'parsed')
access_token <- access_token_body$access_token

search_term <- 'snow -is:retweet lang:en'
recent_search_request <-
  GET(
    url = 'https://api.twitter.com/labs/2/tweets/search',
    query = list(query = search_term, max_results = 50),
    add_headers
    (
      .headers = c(
        'Authorization' = sprintf('Bearer %s', access_token),
        'Content-Type' = 'application/json'
      )
    )
  )

recent_search_body <-
  content(
    recent_search_request,
    as = 'parsed',
    type = 'application/json',
    simplifyDataFrame = TRUE
  )

View(recent_search_body$data)