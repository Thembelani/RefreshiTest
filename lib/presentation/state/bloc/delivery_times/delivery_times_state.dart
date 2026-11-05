part of 'delivery_times_bloc.dart';

@freezed
abstract class DeliveryTimesState with _$DeliveryTimesState {
  const factory DeliveryTimesState({
    @Default([]) List<DeliveryTimeEntity> items,
    @Default(DataStatus.none) DataStatus status,
    BaseFailure? failure,
  }) = _DeliveryTimesState;
}
