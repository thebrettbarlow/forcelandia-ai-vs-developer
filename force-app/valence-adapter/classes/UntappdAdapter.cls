/**
 * Adapter class that allows Valence (https://valence.app) to interact with the Untappd API.
 */
public with sharing class UntappdAdapter implements valence.SourceAdapterScopeSerializer {

	public static void testEndpoint() {
		callAPI('search/beer', new Map<String, String>{
			'q'=>'deschutes',
			'limit'=>'50',
			'sort'=>'name'
		});
		/*callAPI('brewery/checkins/441', new Map<String, String>{
			'max_id'=>'1392871344'
		});*/
		/*callAPI('search/brewery', new Map<String, String>{
			'q' => 'Deschutes' // 441
		});*/
	}

	private static final String endpointURL = 'https://api.untappd.com/v4/';

	public valence.FetchStrategy planFetch(valence.LinkContext context) {
		return valence.FetchStrategy.immediate();
	}

	public List<valence.RecordInFlight> fetchRecords(valence.LinkContext context, Object scope) {
		return null;
	}

	public Object deserializeScope(String serializedScope) {
		return JSON.deserialize(serializedScope, FetchScope.class);
	}

	public String serializeScope(Object scope) {
		return JSON.serialize(scope);
	}

	private static valence.JSONParse callAPI(String methodName, Map<String, String> params) {

		System.debug(LoggingLevel.WARN, 'Calling: ' + methodName + '; ' + JSON.serialize(params));

		HttpRequest req = buildRequest(methodName, params);

		HttpResponse res = new Http().send(req);

		System.debug(LoggingLevel.WARN, res.getStatusCode() + ':' + res.getStatus());
		System.debug(LoggingLevel.WARN, res.getBody());

		checkForHttpErrors(res);

		valence.JSONParse response = new valence.JSONParse(res.getBody());

		return response;
	}

	private static HttpRequest buildRequest(String methodName, Map<String, String> params) {

		params.put('client_id', Untappd_API_Configuration__mdt.getInstance('v4').Client_Id__c);
		params.put('client_secret', Untappd_API_Configuration__mdt.getInstance('v4').Client_Secret__c);
		List<String> paramList = new List<String>();
		for(String key : params.keySet()) {
			paramList.add(key + '=' + EncodingUtil.urlEncode(params.get(key), 'utf8'));
		}

		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setTimeout(120000);
		req.setHeader('Accept', 'application/json');
		req.setHeader('Accept-Encoding', 'gzip');
		req.setCompressed(true);
		req.setEndpoint(
			String.format('{0}{1}?{2}',
				new List<Object>{
					endpointURL,
					methodName,
					String.join(paramList, '&')
				})
		);
		return req;
	}

	/**
	 * Check for errors at the transport layer of an HTTP response.
	 *
	 * @param response The response from the Quickbooks API
	 */
	private static void checkForHttpErrors(HttpResponse response) {
		if(response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
			throw new valence.AdapterException(response.getStatusCode() + ':' + response.getStatus() + '\n ' + response.getBody());
		}
	}

	private class FetchScope {

		private FetchScope() {
		}
	}
}