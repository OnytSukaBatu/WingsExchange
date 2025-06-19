class AsetEntity {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final num currentPrice;
  final num percent;

  const AsetEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.percent,
  });
}
