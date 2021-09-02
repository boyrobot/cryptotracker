import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:local_database/local_database.dart';

class Config {
  static String syncKey = "";
  // static String _api = "https://api.coincap.io/v2/";
  static String HOST = "http://flutter.yoqi.me/Api/";
  HashMap<String, Map<String, dynamic>> _coinData;
  HashMap<String, ValueNotifier<num>> _valueNotifiers =
      HashMap<String, ValueNotifier<num>>();
  List<String> _savedCoins;
  Database _userData;
  Map<String, dynamic> _settings;
  String _symbol;

  LinkedHashSet<String> _supportedCurrencies = LinkedHashSet.from([
    "USD",
    "AUD",
    "BGN",
    "BRL",
    "CAD",
    "CHF",
    "CNY",
    "CZK",
    "DKK",
    "EUR",
    "GBP",
    "HKD",
    "HRK",
    "HUF",
    "IDR",
    "ILS",
    "INR",
    "ISK",
    "JPY",
    "KRW",
    "MXN",
    "MYR",
    "NOK",
    "NZD",
    "PHP",
    "PLN",
    "RON",
    "RUB",
    "SEK",
    "SGD",
    "THB",
    "TRY",
    "ZAR"
  ]);
  Map<String, dynamic> _conversionMap;
  num _exchangeRate;

  bool _loading = false;
}
