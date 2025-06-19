import 'package:wings/domain/entities/aset_entity.dart';

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

  factory AsetModel.fromArray(Map<String, dynamic> json) => AsetModel(
    id: json["id"],
    symbol: json["symbol"],
    name: json["name"],
    image: json["image"],
    currentPrice: json["current_price"],
    percent: json["price_change_percentage_24h"],
  );

  AsetEntity toEntity() {
    return AsetEntity(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice,
      percent: percent,
    );
  }
}
