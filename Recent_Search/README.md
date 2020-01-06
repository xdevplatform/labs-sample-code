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
