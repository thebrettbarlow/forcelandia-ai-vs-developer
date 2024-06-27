final String breweryName = 'Deschutes Brewery';

Untappd_API_Configuration__mdt apiConfig = Untappd_API_Configuration__mdt.getInstance(
  'v4'
);
Map<String, Object> authParams = new Map<String, Object>{
  'url' => apiConfig.URL__c,
  'client_id' => apiConfig.Client_Id__c,
  'client_secret' => apiConfig.Client_Secret__c
};
UntappdApi untappdApi = new UntappdApiImpl(authParams);
UntappdRepository untappdRepository = new UntappdRepositoryImpl();

Map<Long, String> breweries = untappdApi.searchBreweries(breweryName);
System.debug('Breweries: ' + breweries);

UntappdBrewery brewery;
for (Long id : breweries.keySet()) {
  if (breweries.get(id) == breweryName) {
    brewery = untappdApi.getBreweryInfo(id);
  }
}

if (brewery == null) {
  throw new IllegalArgumentException(
    String.format(
      'Brewery ({0}) not found in Untappd.',
      new List<Object>{ breweryName }
    )
  );
}

System.debug(String.format('We found {0}!', new List<Object>{ breweryName }));
System.debug(
  String.format(
    String.join(
      new List<String>{ '{0} ({1})', '{2}', '{3} {4}, {5}', '{6}' },
      '\n'
    ),
    new List<Object>{
      brewery.getName(),
      brewery.getId(),
      brewery.getWebsite(),
      brewery.getStreet(),
      brewery.getCity(),
      brewery.getState(),
      brewery.getDescription()
    }
  )
);
System.debug(
  String.format('Beers: {0}', new List<Object>{ brewery.getBeers().size() })
);
for (UntappdBeer beer : brewery.getBeers()) {
  System.debug(
    String.format(
      '{0} ({1} {2}%)',
      new List<Object>{ beer.getName(), beer.getStyle(), beer.getAbv() }
    )
  );
}

List<UntappdCheckIn> checkIns = new List<UntappdCheckIn>();
for (UntappdBeer untappdBeer : brewery.getBeers()) {
  List<UntappdCheckIn> beerCheckIns = untappdApi.getBeerCheckIns(
    untappdBeer.getId()
  );
  System.debug(
    String.format(
      'Check-Ins for {0}',
      new List<Object>{ untappdBeer.getName() }
    )
  );
  for (UntappdCheckIn checkIn : beerCheckIns) {
    String summary = checkIn.getRating().toString();

    if (String.isNotBlank(checkIn.getComment())) {
      summary += ' - ' + checkIn.getComment();
    }

    System.debug(summary);
  }

  checkIns.addAll(beerCheckIns);
}

untappdRepository.upsertBrewery(brewery);
untappdRepository.upsertBeers(brewery.getBeers());
untappdRepository.upsertCheckins(checkIns);