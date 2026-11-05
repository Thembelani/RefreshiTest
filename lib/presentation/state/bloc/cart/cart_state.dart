part of 'cart_bloc.dart';

@freezed
abstract class CartState with _$CartState {
  const CartState._();

  const factory CartState({
    CartEntity? cart,
    DeliveryEntity? delivery,
    PaymentEntity? payment,
    @Default([]) List<CartItemEntity> items,
    @Default(DataStatus.none) DataStatus status,
    BaseFailure? failure,
    @Default(false) bool checkoutPrepared,
  }) = _CartState;

  List<CartItemEntity> get activeItems => items
      .where((item) => item.deletedAt == null && item.quantity > 0)
      .toList();

  int get itemCount =>
      activeItems.fold(0, (total, item) => total + item.quantity);

  int quantityFor(int catalogItemId) {
    for (final item in items) {
      if (item.catalogItemId == catalogItemId && item.deletedAt == null) {
        return item.quantity;
      }
    }
    return 0;
  }
}
