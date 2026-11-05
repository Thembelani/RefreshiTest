class PaymentEntity {
  int id;
  int cartId;
  String token;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  PaymentEntity({
    required this.id,
    required this.cartId,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
