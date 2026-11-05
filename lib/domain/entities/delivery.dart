class DeliveryEntity {
  int id;
  int cartId;
  String street;
  String city;
  String postalCode;
  int? deliveryTimeId;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  DeliveryEntity({
    required this.id,
    required this.cartId,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryTimeId,
    this.deletedAt,
  });
}
