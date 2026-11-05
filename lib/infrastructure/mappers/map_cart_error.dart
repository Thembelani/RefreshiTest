import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/failures/cart_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';

extension CartErrorExtension on BaseGraphError {
  BaseFailure toCartFailure() {
    return switch (type) {
      GraphQlErrorType.cartError => CartFailure(),
      GraphQlErrorType.cartParseError => CartParseFailure(),
      GraphQlErrorType.cartItemError => CartItemFailure(),
      GraphQlErrorType.cartItemParseError => CartItemParseFailure(),
      GraphQlErrorType.getCatalogItemError => CartFailure(),
      GraphQlErrorType.getCatalogItemParseError => CartParseFailure(),
      GraphQlErrorType.deliveryError => CartFailure(),
      GraphQlErrorType.deliveryParseError => CartParseFailure(),
      GraphQlErrorType.paymentError => CartFailure(),
      GraphQlErrorType.paymentParseError => CartParseFailure(),
      GraphQlErrorType.deliveryTimeError => CartFailure(),
      GraphQlErrorType.deliveryTimeParseError => CartParseFailure(),
    };
  }
}
