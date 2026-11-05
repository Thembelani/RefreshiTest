import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/delivery_time/get_delivery_times_use_case.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/domain/entities/delivery_time.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

part 'delivery_times_event.dart';
part 'delivery_times_state.dart';
part 'delivery_times_bloc.freezed.dart';

@lazySingleton
class DeliveryTimesBloc extends Bloc<DeliveryTimesEvent, DeliveryTimesState> {
  DeliveryTimesBloc(this._getDeliveryTimesUseCase)
      : super(const DeliveryTimesState()) {
    on<DeliveryTimesEvent>((event, emit) async {
      await event.when(
        getDeliveryTimes: () => _getDeliveryTimes(emit),
      );
    });
  }

  final GetDeliveryTimesUseCase _getDeliveryTimesUseCase;

  Future<void> _getDeliveryTimes(Emitter<DeliveryTimesState> emit) async {
    emit(state.copyWith(status: DataStatus.loading));

    final result =
        await _getDeliveryTimesUseCase.call(const NoParams()).run();

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          items: [],
          status: DataStatus.error,
        ),
      ),
      (items) => emit(
        state.copyWith(
          failure: null,
          items: items,
          status: DataStatus.success,
        ),
      ),
    );
  }
}
