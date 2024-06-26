/**
 * Adapter class that allows Valence (https://valence.app) to interact with the Untappd API.
 */
global with sharing class UntappdAdapter implements valence.SourceAdapterScopeSerializer, valence.SchemaAdapter, valence.ConfigurableSourceAdapter {

	public static void testEndpoint() {
		/*callAPI('search/beer', new Map<String, String>{
			'q'=>'deschutes',
			'limit'=>'50',
			'sort'=>'name'
		});*/
		/*callAPI('brewery/checkins/441', new Map<String, String>{
			'max_id'=>'1392871344'
		});*/
		callAPI('search/brewery', new Map<String, String>{
			'q' => 'beer' // 441
		});
	}

	private static final String endpointURL = 'https://api.untappd.com/v4/';

	private SourceConfiguration sourceConfig;

	public List<valence.Table> getTables() {
		return new List<valence.Table>{
			valence.Table.create('search_brewery')
				.withLabel('Brewery Search')
				.withDescription('Perform a text search for a Brewery name.')
				.build(),
			valence.Table.create('brewery_info')
				.withLabel('Brewery Info')
				.withDescription('Given a Brewery Id, get additional information about that Brewery.')
				.build(),
			valence.Table.create('activity_beer')
				.withLabel('Beer Activity Feed')
				.withDescription('Get Check-in activity records for a Beer Id.')
				.build()
		};
	}

	public List<valence.Field> getFields(String tableName) {
		return null;
	}

	public String explainSourceConfiguration(valence.LinkContext context, String configData) {
		SourceConfiguration config = parseSourceConfig(configData);
		if('search_brewery'.equalsIgnoreCase(context.linkSourceName)) {
			if(String.isNotBlank(config.q)) {
				return String.format('<p>Search term: <strong>{0}</strong>.</p>', new List<Object>{config.q});
			}
			else {
				return '<span class="slds-text-color_error">Search term needed. Click "Configure" on Data Source.</span>';
			}
		}
		else {
			return null;
		}
	}

	public String getSourceConfigurationLightningComponent(valence.LinkContext context) {
		return null;
	}

	public String getSourceConfigurationStructure(valence.LinkContext context) {
		if('search_brewery'.equalsIgnoreCase(context.linkSourceName)) {
			return '{"description":"What Brewery name shall we search?","fields" : [{"name":"q"}]}';
		}
		else {
			return null;
		}
	}

	public void setSourceConfiguration(valence.LinkContext context, String configData) {
		sourceConfig = parseSourceConfig(configData);
	}

	public valence.FetchStrategy planFetch(valence.LinkContext context) {
		List<FetchScope> scopes = new List<FetchScope>();
		switch on context.linkSourceName {
			when 'search_brewery' {
				scopes.add(new FetchScope(
					'search/brewery',
					'response.brewery.items',
					new Map<String, String>{
						'q' => sourceConfig.q
					}
				));
			}
			when 'brewery_info' {
				for(Account brewery : [SELECT Name, Untappd_Id__c FROM Account WHERE Untappd_Id__c != NULL]) {
					scopes.add(new FetchScope(
						'brewery/info/' + brewery.Untappd_Id__c,
						'response.brewery'
					));
				}
			}
			when 'activity_beer' {
				for(Beer__c beer : [SELECT Name, Untappd_Id__c FROM Beer__c WHERE Untappd_Id__c != NULL]) {
					scopes.add(new FetchScope(
						'beer/checkins/' + beer.Untappd_Id__c,
						'response.checkins.items'
					));
				}
			}
		}
		if(scopes.isEmpty()) {
			return valence.FetchStrategy.noRecords();
		}
		else {
			return valence.FetchStrategy.scopes(scopes);
		}
	}

	public List<valence.RecordInFlight> fetchRecords(valence.LinkContext context, Object scope) {
		FetchScope fetchScope = (FetchScope)scope;
		List<valence.RecordInFlight> records = new List<valence.RecordInFlight>();
		valence.JSONParse result = callAPI(fetchScope.partialURL, fetchScope.params);
		valence.JSONParse payload = result.get(fetchScope.responsePath);
		if(payload.isArray()) {
			for(valence.JSONParse item : payload.asList()) {
				records.add(new valence.RecordInFlight((Map<String, Object>)item.getValue()));
			}
		}
		else {
			records.add(new valence.RecordInFlight((Map<String, Object>)payload.getValue()));
		}
		return records;
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

	private static SourceConfiguration parseSourceConfig(String configData) {
		if(String.isNotBlank(configData)) {
			return (SourceConfiguration)JSON.deserialize(configData, SourceConfiguration.class);
		}
		else {
			return new SourceConfiguration();
		}
	}

	private class SourceConfiguration {
		private String q;
	}

	private class FetchScope {

		private final String partialURL;
		private final String responsePath;
		private Map<String, String> params = new Map<String, String>();

		private FetchScope() {
		}

		private FetchScope(String partialURL, String responsePath) {
			this.partialURL = partialURL;
			this.responsePath = responsePath;
		}

		private FetchScope(String partialURL, String responsePath, Map<String, String> params) {
			this.partialURL = partialURL;
			this.responsePath = responsePath;
			this.params = new Map<String, String>(params);
		}
	}
}