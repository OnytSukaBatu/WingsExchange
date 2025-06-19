class MainConfig {
  static String stringPIN = 'MobileCachePIN';
  static String stringEmail = 'MobileCacheEmail';
  static String stringDisplay = 'MobileCacheDisplay';
  // static String stringTransaction = 'MobileTransaction';
  static String stringApiKey = 'MobileCacheApiKey';
  // static String stringRupiah = 'MobileCacheRupaih';
  static String stringID = 'MobileCacheID';
  static String boolLogin = 'MobileCacheLogin';

  static String urlListMarket =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=idr';
  static String urlAsetPrice =
      'https://api.coingecko.com/api/v3/simple/price?vs_currencies=idr&ids=';
}

enum PINmethod { result, create, secure }
