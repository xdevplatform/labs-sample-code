## Labs recent search example code

### Getting started examples

/quick-starts

These examples are included in the Labs recent search Quick Start guide:
https://developer.twitter.com/en/docs/labs/recent-search/quick-start.

Recent search "Quick start" examples are meant to help you get started with the endpoint. To use these scripts, copy in your Twitter App consumer key and secret tokens and run it. Using these consumer (app) tokens, these scripts request a Bearer Token from the Twitter platform. These scripts then make a single request to the Recent search endpoint and quit. The scripts do not look for a ```next_token```, which is included in endpoint responses when there is more matching Tweets available.

While these scripts are OK for making some practice requests, they hard-code keys and do not implement any form of pagination. 

If you are developing in Python or Ruby, the following examples are a bit more advanced.

### Next steps

 These scripts:

+ Load authentication tokens from a .env file. 
+ Implement pagination and enable a "maximum requests" to be set.

**/Python

[/Python/recent-search.py](https://github.com/twitterdev/labs-sample-code/blob/master/Recent_Search/Python/recent-search.py)


**/Ruby

[/Ruby/recent-search.rb ](https://github.com/twitterdev/labs-sample-code/blob/master/Recent_Search/Ruby/recent-search.rb)


**/JavaScript
=======
# Sample code

This repository contains sample applications inspired by the [quick start guides](https://developer.twitter.com/en/docs/labs/recent-search/quick-start). The scripts included in this folder allow you to:

1. Obtain a Bearer token
1. Get the 10 most recent results for the query specified

`recent_search.js`, `recent_search.py` and `recent_search.rb` allow you to run the above flow in JavaScript, Python and Ruby for Recent search.

## Authentication

In order to successfully run the scripts, you must add your Twitter application credentials at the top of each file, where indicated. Remember to remove these credentials when done.
