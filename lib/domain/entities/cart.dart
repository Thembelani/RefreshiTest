class CartEntity {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  CartEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
