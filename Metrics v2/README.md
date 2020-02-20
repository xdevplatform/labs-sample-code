# Sample code

This repository contains sample applications inspired by the [quick start guides](https://developer.twitter.com/en/docs/labs/tweet-metrics/quick-start). The scripts included in this folder allow you to query a list of up to 50 Tweet ID(s) and will return engagement metrics for this Tweet.

The Tweet(s) you query must be from owned/authorized accounts, cannot be older than 30 days and cannot be Retweets.

`get_tweets_metrics_private.js`, `get_tweets_metrics_private.py` and `get_tweets_metrics_private.rb` allow you to get a sample payload in JavaScript, Python and Ruby for the [GET /tweets/metrics/private endpoint](https://twittercommunity.com/t/new-twitter-developer-labs-release-metrics-endpoint/129122).

## Authentication

In order to successfully run the scripts, you must add your Twitter application credentials at the top of each file, where indicated.

## Parameters

Running `get_tweets_metrics_private.js` and `get_tweets_metrics_private.py` will prompt you to pass the Tweet ID(s) you wish to query as a parameter via the command line.

In `get_tweets_metrics_private.rb`, you will have to add the Tweet ID(s) directly in the script, as indicated above `@TweetIDs = ''`.
