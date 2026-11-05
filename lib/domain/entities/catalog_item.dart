class CatalogItemEntity {
  int id;
  String name;
  double sellingPrice;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  CatalogItemEntity({
    required this.id,
    required this.name,
    required this.sellingPrice,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
