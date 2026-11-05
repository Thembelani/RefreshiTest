part of 'cart_bloc.dart';

@freezed
sealed class CartEvent with _$CartEvent {
  const factory CartEvent.startCart() = StartCart;
  const factory CartEvent.addCatalogItem({required int catalogItemId}) =
      AddCatalogItem;
  const factory CartEvent.decrementCatalogItem({required int catalogItemId}) =
      DecrementCatalogItem;
  const factory CartEvent.removeCartItem({required int cartItemId}) =
      RemoveCartItem;
  const factory CartEvent.prepareCheckout() = PrepareCheckout;
  const factory CartEvent.ensureCheckoutDetails() = EnsureCheckoutDetails;
  const factory CartEvent.selectDeliveryTime({required int deliveryTimeId}) =
      SelectDeliveryTime;
}
