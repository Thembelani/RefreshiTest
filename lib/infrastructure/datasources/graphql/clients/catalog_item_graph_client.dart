
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/graphql_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_catalog_items.graphql.dart';


@lazySingleton
class CatalogItemGraphClient {
  CatalogItemGraphClient(this._graphql);

  final GraphqlClient _graphql;

  TaskEither<BaseGraphError, List<Query$GetCatalogItems$getCatalogItems>>
  getCatalogItems() {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetCatalogItems(), 
      (error, stacktrace) => BaseGraphError(
        error: error,
        stackTrace: stacktrace,
        type: GraphQlErrorType.getCatalogItemError, 
      )
    ).map((res) => res.parsedData!.getCatalogItems);
  }
}