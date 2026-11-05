part of 'order_summary_bloc.dart';

@freezed
sealed class OrderSummaryEvent with _$OrderSummaryEvent {
  const factory OrderSummaryEvent.load({required int cartId}) =
      LoadOrderSummary;
  const factory OrderSummaryEvent.fulfillPayment() = FulfillPayment;
}
