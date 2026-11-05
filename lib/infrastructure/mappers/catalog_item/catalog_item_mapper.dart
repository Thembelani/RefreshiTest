import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_catalog_items.graphql.dart';

import 'catalog_item_mapper.auto_mappr.dart';

@lazySingleton
@AutoMappr([
  MapType<Query$GetCatalogItems$getCatalogItems, CatalogItemEntity>(
    fields: [
      Field.custom('id', custom: CatalogItemGraphModelToEntityMapper.parseId),
      Field.custom(
        'createdAt',
        custom: CatalogItemGraphModelToEntityMapper.parseCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: CatalogItemGraphModelToEntityMapper.parseUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: CatalogItemGraphModelToEntityMapper.parseDeletedAt,
      ),
    ],
  ),
])
class CatalogItemGraphModelToEntityMapper
    extends $CatalogItemGraphModelToEntityMapper {
  static int parseId(Query$GetCatalogItems$getCatalogItems model) =>
      int.parse(model.id);

  static DateTime parseCreatedAt(Query$GetCatalogItems$getCatalogItems model) =>
      DateTime.parse(model.createdAt);

  static DateTime parseUpdatedAt(Query$GetCatalogItems$getCatalogItems model) =>
      DateTime.parse(model.updatedAt);

  static DateTime? parseDeletedAt(
    Query$GetCatalogItems$getCatalogItems model,
  ) => model.deletedAt == null ? null : DateTime.parse(model.deletedAt!);
}
