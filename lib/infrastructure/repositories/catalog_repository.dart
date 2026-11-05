import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_catalog_repository.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/clients/catalog_item_graph_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_catalog_items.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/catalog_item/catalog_item_mapper.dart';
import 'package:refreshi_test/infrastructure/mappers/map_catalog_item_error.dart';

@LazySingleton(as: ICatalogRepository)
class CatalogRepository implements ICatalogRepository {

  CatalogRepository(this._client, this._mapper);

  final CatalogItemGraphClient _client;
  final CatalogItemGraphModelToEntityMapper _mapper;

  @override
  TaskEither<BaseFailure, List<CatalogItemEntity>> getCatalogItems() {
    return _client.getCatalogItems()
    .flatMap((items) => TaskEither.traverseList(items, _mapCatalogItemModelToEntity))
    .mapLeft((error) => error.toFailure());
  }

  TaskEither<BaseGraphError, CatalogItemEntity> _mapCatalogItemModelToEntity(
    Query$GetCatalogItems$getCatalogItems? model,
  ) {
    return TaskEither.tryCatch(
      () => Future.sync(() =>
          _mapper.convert<Query$GetCatalogItems$getCatalogItems, CatalogItemEntity>(model)),
      (Object error, StackTrace stackTrace) => BaseGraphError(
        type: GraphQlErrorType.getCatalogItemParseError,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }






}