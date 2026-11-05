import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/catalog_item/get_catalog_items_use_case.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

part 'catalog_items_event.dart';
part 'catalog_items_state.dart';
part 'catalog_items_bloc.freezed.dart';

@lazySingleton
class CatalogItemsBloc extends Bloc<CatalogItemsEvent, CatalogItemsState> {
  CatalogItemsBloc(this._getCatalogItemsUseCase)
      : super(const CatalogItemsState()) {
    on<CatalogItemsEvent>((event, emit) async {
      await event.when(
        getCatalogItems: () => _getCatalogItems(emit),
      );
    });
  }

  final GetCatalogItemsUseCase _getCatalogItemsUseCase;

  Future<void> _getCatalogItems(Emitter<CatalogItemsState> emit) async {
    emit(state.copyWith(status: DataStatus.loading));

    final result =
        await _getCatalogItemsUseCase.call(const NoParams()).run();

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
