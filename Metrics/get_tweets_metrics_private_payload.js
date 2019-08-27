const qs = require('querystring');
const request = require('request');
const readline = require('readline').createInterface({
  input: process.stdin,
  output: process.stdout
});
const util = require('util');

const get = util.promisify(request.get);
const post = util.promisify(request.post);

const consumer_key = ''; // Add your API key
const consumer_secret = ''; // Add your API secret key

const requestTokenURL = new URL('https://api.twitter.com/oauth/request_token');
const accessTokenURL = new URL('https://api.twitter.com/oauth/access_token');
const authorizeURL = new URL('https://api.twitter.com/oauth/authorize');
const endpointURL = new URL('https://api.twitter.com/labs/1/tweets/metrics/private');

async function input(prompt) {
  return new Promise(async (resolve, reject) => {
    readline.question(prompt, (out) => {
      resolve(out);
    });
  });
}

async function accessToken({
  oauth_token,
  oauth_token_secret
}, verifier) {
  const oAuthConfig = {
    consumer_key: consumer_key,
    consumer_secret: consumer_secret,
    token: oauth_token,
    token_secret: oauth_token_secret,
    verifier: verifier,
  };

  const req = await post({
    url: accessTokenURL,
    oauth: oAuthConfig
  });
  if (req.body) {
    return qs.parse(req.body);
  } else {
    throw new Error('Cannot get an OAuth request token');
  }
}

async function requestToken() {
  const oAuthConfig = {
    callback: 'oob',
    consumer_key: consumer_key,
    consumer_secret: consumer_secret,
  };

  const req = await post({
    url: requestTokenURL,
    oauth: oAuthConfig
  });
  if (req.body) {
    return qs.parse(req.body);
  } else {
    throw new Error('Cannot get an OAuth request token');
  }
}

async function getRequest({
  oauth_token,
  oauth_token_secret
}, params) {
  const oAuthConfig = {
    consumer_key: consumer_key,
    consumer_secret: consumer_secret,
    token: oauth_token,
    token_secret: oauth_token_secret,
  };

  const req = await get({
    url: endpointURL,
    oauth: oAuthConfig,
    qs: params,
    json: true
  });
  if (req.body) {
    return req.body;
  } else {
    throw new Error('Cannot get an OAuth request token');
  }
}

(async () => {
  try {

    // Get request token
    const oAuthRequestToken = await requestToken();

    // Get authorization
    authorizeURL.searchParams.append('oauth_token', oAuthRequestToken.oauth_token);
    console.log('Please go here and authorize:', authorizeURL.href);
    const pin = await input('Paste the PIN here: ');

    // Get the access token
    const oAuthAccessToken = await accessToken(oAuthRequestToken, pin.trim());

    // You can input up to 50 comma-separated Tweet IDs.
    const params = {
      ids: ''
    };

    // Make the request and return response
    const response = await getRequest(oAuthAccessToken, params);
    console.log(response.data)
    if (response.hasOwnProperty('errors')) {
      console.log(response.errors)
    }

  } catch (e) {
    console.error(e);
    process.exit(-1);
  }
  process.exit();
})();
