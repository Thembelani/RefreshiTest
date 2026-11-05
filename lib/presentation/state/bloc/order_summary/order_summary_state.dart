part of 'order_summary_bloc.dart';

@freezed
abstract class OrderSummaryState with _$OrderSummaryState {
  const OrderSummaryState._();

  const factory OrderSummaryState({
    CartEntity? cart,
    DeliveryEntity? delivery,
    PaymentEntity? payment,
    @Default([]) List<CartItemEntity> items,
    @Default(DataStatus.none) DataStatus status,
    BaseFailure? failure,
    @Default(false) bool fulfillmentRequested,
  }) = _OrderSummaryState;

  bool get isPlaced => cart?.placedAt != null;

  bool get isFulfilled => payment?.fulfilled == true;
}
