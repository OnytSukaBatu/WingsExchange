class DataModel {
  final String id;
  final double price;
  final double aset;
  final String image;
  final String name;

  DataModel({required this.id, required this.price, required this.aset, required this.image, required this.name});

  factory DataModel.fromArray(Map<String, dynamic> json) {
    return DataModel(id: json["id"], price: json["price"].toDouble(), aset: json["aset"].toDouble(), image: json["image"], name: json["name"]);
  }

  Map<String, dynamic> toArray() {
    return {"id": id, "price": price, "aset": aset, "image": image, "name": name};
  }
}
