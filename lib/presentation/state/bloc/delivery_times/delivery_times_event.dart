part of 'delivery_times_bloc.dart';

@freezed
sealed class DeliveryTimesEvent with _$DeliveryTimesEvent {
  const factory DeliveryTimesEvent.getDeliveryTimes() = GetDeliveryTimes;
}
