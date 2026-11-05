part of 'catalog_items_bloc.dart';

@freezed
sealed class CatalogItemsEvent with _$CatalogItemsEvent {
  const factory CatalogItemsEvent.getCatalogItems() = GetCatalogItems;
}
