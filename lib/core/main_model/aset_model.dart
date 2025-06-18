import 'dart:convert';

class AsetModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final num currentPrice;
  final num percent;

  AsetModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.percent,
  });

  factory AsetModel.fromJson(String str) => AsetModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AsetModel.fromMap(Map<String, dynamic> json) => AsetModel(
    id: json["id"],
    symbol: json["symbol"],
    name: json["name"],
    image: json["image"],
    currentPrice: json["current_price"],
    percent: json["price_change_percentage_24h"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "image": image,
    "current_price": currentPrice,
    "price_change_percentage_24h": percent,
  };
}
