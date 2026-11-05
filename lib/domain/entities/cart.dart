class CartEntity {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? placedAt;
  DateTime? deletedAt;

  CartEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.placedAt,
    this.deletedAt,
  });
}
