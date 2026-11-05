class DeliveryTimeEntity {
  int id;
  String day;
  String time;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  DeliveryTimeEntity({
    required this.id,
    required this.day,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
