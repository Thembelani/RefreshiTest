import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/failures/catalog_item_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';

extension CatalogItemErrorExtension on BaseGraphError {
  BaseFailure toFailure() {
    return switch (type) {
      GraphQlErrorType.getCatalogItemError => GetCatalogItemFailure(),
      GraphQlErrorType.getCatalogItemParseError => GetCatalogItemParseFailure(),
      GraphQlErrorType.cartError => GetCatalogItemFailure(),
      GraphQlErrorType.cartParseError => GetCatalogItemParseFailure(),
      GraphQlErrorType.cartItemError => GetCatalogItemFailure(),
      GraphQlErrorType.cartItemParseError => GetCatalogItemParseFailure(),
    };
  }
}
