class AssetsEntity {
  List<CoinModel> coins = <CoinModel>[];
  double timestamp;

  AssetsEntity(this.coins, this.timestamp);

  AssetsEntity.fromJson(Map<String, dynamic> json) {
    if (json["data"] is List) {
      (json["data"] as List).forEach((element) {
        coins.add(CoinModel.fromJson(element));
      });
    }
    timestamp = json["timestamp"];
  }
}

class CoinModel {
  String id;
  int rank;
  String symbol;
  String name;
  double supply;
  double maxsupply;
  double marketCapUsd;
  double volumeUsd24Hr;
  double priceUsd;
  double changePercent24Hr;
  double vwap24Hr;
  String explorer;

  CoinModel(
      this.id,
      this.rank,
      this.symbol,
      this.name,
      this.supply,
      this.maxsupply,
      this.marketCapUsd,
      this.volumeUsd24Hr,
      this.priceUsd,
      this.changePercent24Hr,
      this.vwap24Hr,
      this.explorer);

  CoinModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    rank = json["rank"];
    symbol = json["symbol"];
    name = json["name"];
    supply = double.parse(json["supply"]);
    maxsupply = double.parse(json["maxsupply"]);
    marketCapUsd = double.parse(json["marketCapUsd"]);
    volumeUsd24Hr = double.parse(json["volumeUsd24Hr"]);
    priceUsd = double.parse(json["priceUsd"]);
    changePercent24Hr = double.parse(json["changePercent24Hr"]);
    vwap24Hr = double.parse(json["vwap24Hr"]);
    explorer = json["explorer"];
  }
}
