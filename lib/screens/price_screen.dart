import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../misc/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  CoinData coinData = CoinData();

  String _selectedCurrency = 'AUD';
  double bitcoinRate;


  // WIDGETS
  DropdownButton<String> androidDropdown() {
    return DropdownButton<String>(
      value: _selectedCurrency,
      items: currenciesList.map((currency) => new DropdownMenuItem(
        child: Text(currency),
        value: currency,))
          .toList(),

      onChanged: (value) {
        setState(() {
          _selectedCurrency = value;
          print(value);});
        },
    );
  }
  CupertinoPicker iOSPicker() {

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (_selectedIndex){
        setState(() {
          _selectedCurrency = currenciesList[_selectedIndex];
        });
      },
      children: currenciesList.map((currency) => new Text(currency)).toList());
  }
  List<Widget> getCardList(CoinData data, String currency) {
    return cryptoList.map((crypto) => CryptoCard(coinData: data, selectedCrypto: crypto, selectedCurrency: currency)).toList();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getCardList(coinData, _selectedCurrency)
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown()
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.coinData,
    @required this.selectedCrypto,
    @required this.selectedCurrency});

  final CoinData coinData;
  final String selectedCrypto;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: FutureBuilder(
            future: coinData.getCoinData(selectedCrypto, selectedCurrency),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.none: return new Text('None');
                case ConnectionState.waiting: return new Text('Waiting');
                default:
                  if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                  else return new Text('1 $selectedCrypto = ${snapshot.data} $selectedCurrency');
              }
            },
          )
        ),
      ),
    );
  }
}