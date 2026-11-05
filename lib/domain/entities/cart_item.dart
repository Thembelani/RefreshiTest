class CartItemEntity {
  int id;
  int cartId;
  int catalogItemId;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  CartItemEntity({
    required this.id,
    required this.cartId,
    required this.catalogItemId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
