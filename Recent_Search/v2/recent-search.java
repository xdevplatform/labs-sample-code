/*
 * Sample code to demonstrate the use of the Labs recent Search endpoint
 * */
public class RecentSearchDemo {

    //FIXME Replace the keys below with your own keys and secret
    private static final String API_KEY = "";
    private static final String API_SECRET = "";

    public static void main(String args[]) throws IOException, URISyntaxException {
        //Replace the search term with a term of your choice
        String response = search("(Labs Search Twitter) OR from:TwitterDev OR from:SnowBotDev OR from:DailyNASA");
        System.out.println(response);
    }

    /*
    * This method calls the recent search endpoint with a the search term passed to it as a query parameter
    * */
    private static String search(String searchString) throws IOException, URISyntaxException {
        String searchResponse = null;

        HttpClient httpClient = HttpClients.custom()
                .setDefaultRequestConfig(RequestConfig.custom()
                        .setCookieSpec(CookieSpecs.STANDARD).build())
                .build();

        URIBuilder uriBuilder = new URIBuilder("https://api.twitter.com/labs/2/tweets/search");
        ArrayList<NameValuePair> queryParameters;
        queryParameters = new ArrayList<>();
        queryParameters.add(new BasicNameValuePair("query", searchString));
        uriBuilder.addParameters(queryParameters);

        HttpGet httpGet = new HttpGet(uriBuilder.build());
        httpGet.setHeader("Authorization", String.format("Bearer %s", getAccessToken()));
        httpGet.setHeader("Content-Type", "application/json");
        httpGet.setHeader("User-Agent", "LabsRecentSearchQuickStartJava");

        HttpResponse response = httpClient.execute(httpGet);
        HttpEntity entity = response.getEntity();
        if (null != entity) {
            searchResponse = EntityUtils.toString(entity, "UTF-8");
        }
        return searchResponse;
    }

    /*
     * Helper method that generates bearer token by calling the /oauth2/token endpoint
     * */
    private static String getAccessToken() throws IOException, URISyntaxException {
        String accessToken = null;

        HttpClient httpClient = HttpClients.custom()
                .setDefaultRequestConfig(RequestConfig.custom()
                        .setCookieSpec(CookieSpecs.STANDARD).build())
                .build();

        URIBuilder uriBuilder = new URIBuilder("https://api.twitter.com/oauth2/token");
        ArrayList<NameValuePair> postParameters;
        postParameters = new ArrayList<>();
        postParameters.add(new BasicNameValuePair("grant_type", "client_credentials"));
        uriBuilder.addParameters(postParameters);

        HttpPost httpPost = new HttpPost(uriBuilder.build());
        httpPost.setHeader("Authorization", String.format("Basic %s", getBase64EncodedString()));
        httpPost.setHeader("Content-Type", "application/json");

        HttpResponse response = httpClient.execute(httpPost);
        HttpEntity entity = response.getEntity();

        if (null != entity) {
            try (InputStream inputStream = entity.getContent()) {
                ObjectMapper mapper = new ObjectMapper();
                Map<String, Object> jsonMap = mapper.readValue(inputStream, Map.class);
                accessToken = jsonMap.get("access_token").toString();
            }
        }
        return accessToken;
    }

    /*
     * Helper method that generates the Base64 encoded string to be used to obtain bearer token
     *
     * */
    private static String getBase64EncodedString() {
        String s = String.format("%s:%s", API_KEY, API_SECRET);
        return Base64.getEncoder().encodeToString(s.getBytes(StandardCharsets.UTF_8));
    }
}