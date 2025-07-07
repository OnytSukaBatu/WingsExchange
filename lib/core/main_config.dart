class MainConfig {
  static String stringPIN = 'MobileCachePIN';
  static String stringEmail = 'MobileCacheEmail';
  static String stringDisplay = 'MobileCacheDisplay';
  static String stringApiKey = 'MobileCacheApiKey';
  static String boolLogin = 'MobileCacheLogin';
  static String boolTheme = 'MobileCacheTheme';

  static String urlListMarket = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=idr';
  static String urlAsetPrice = 'https://api.coingecko.com/api/v3/simple/price?vs_currencies=idr&ids=';
  static String urlChart0 = 'https://api.coingecko.com/api/v3/coins/';
  static String urlChart1 = '/market_chart?vs_currency=idr&days=';
  static String urlChart2 = '&interval=daily';
}

enum PINmethod { result, create, secure, confirm }
