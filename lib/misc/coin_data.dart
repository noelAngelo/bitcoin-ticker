import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'dart:io' show File;


const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];


const String baseURL = 'https://rest.coinapi.io/v1/exchangerate';
const String apiKey = 'C08AA1E7-8FF3-48DC-ACC5-40F3D24867D0';
const String path = '/Users/noelangeloborneo/AndroidStudioProjects/bitcoin-ticker-flutter/lib/json/config.json';

class CoinData {

  Future<String> getCoinData(String crypto, String fiat) async {
//    String apiKey = await authenticate();
    String uri = '$baseURL/$crypto/$fiat';
    print('$uri : $apiKey');
    var response = await http.get(
        uri, headers: {'X-CoinAPI-Key': apiKey}
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var rate = jsonResponse['rate'].round();
      return NumberFormat.simpleCurrency(name: fiat).format(rate).toString();
    } else print(response.body.toString());
    return null;
  }
}

Future<String> authenticate() async {
  var file = File(path);
  var contents;

  if(await file.exists()) {
    contents = await file.readAsString();
    return convert.jsonDecode(contents)['apikey'];

  } else print('read failed');
  return null;
}