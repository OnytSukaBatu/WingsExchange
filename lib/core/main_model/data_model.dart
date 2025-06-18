import 'dart:convert';

class DataModel {
  final String id;
  final double price;
  final double aset;
  final String image;
  final String name;

  DataModel({
    required this.id,
    required this.price,
    required this.aset,
    required this.image,
    required this.name,
  });

  factory DataModel.fromJson(String str) => DataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
    id: json["id"],
    price: json["price"].toDouble(),
    aset: json["aset"].toDouble(),
    image: json["image"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "price": price,
    "aset": aset,
    "image": image,
    "name": name,
  };
}
