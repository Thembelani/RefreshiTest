import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/failures/delivery_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';

extension DeliveryErrorExtension on BaseGraphError {
  BaseFailure toDeliveryFailure() {
    return switch (type) {
      GraphQlErrorType.deliveryError => DeliveryFailure(),
      GraphQlErrorType.deliveryParseError => DeliveryParseFailure(),
      GraphQlErrorType.getCatalogItemError => DeliveryFailure(),
      GraphQlErrorType.getCatalogItemParseError => DeliveryParseFailure(),
      GraphQlErrorType.cartError => DeliveryFailure(),
      GraphQlErrorType.cartParseError => DeliveryParseFailure(),
      GraphQlErrorType.cartItemError => DeliveryFailure(),
      GraphQlErrorType.cartItemParseError => DeliveryParseFailure(),
      GraphQlErrorType.paymentError => DeliveryFailure(),
      GraphQlErrorType.paymentParseError => DeliveryParseFailure(),
      GraphQlErrorType.deliveryTimeError => DeliveryFailure(),
      GraphQlErrorType.deliveryTimeParseError => DeliveryParseFailure(),
    };
  }
}
