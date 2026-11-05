class PaymentEntity {
  int id;
  int cartId;
  String token;
  bool fulfilled;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  PaymentEntity({
    required this.id,
    required this.cartId,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
    this.fulfilled = false,
    this.deletedAt,
  });
}
