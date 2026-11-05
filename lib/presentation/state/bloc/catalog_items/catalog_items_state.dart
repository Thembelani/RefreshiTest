part of 'catalog_items_bloc.dart';

@freezed
abstract class CatalogItemsState with _$CatalogItemsState {
  const factory CatalogItemsState({
    @Default([]) List<CatalogItemEntity> items,
    @Default(DataStatus.none) DataStatus status,
    BaseFailure? failure,
  }) = _CatalogItemsState;
}
