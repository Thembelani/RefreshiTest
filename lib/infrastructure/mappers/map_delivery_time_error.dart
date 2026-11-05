import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/failures/delivery_time_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';

extension DeliveryTimeErrorExtension on BaseGraphError {
  BaseFailure toDeliveryTimeFailure() {
    return switch (type) {
      GraphQlErrorType.deliveryTimeError => GetDeliveryTimeFailure(),
      GraphQlErrorType.deliveryTimeParseError => GetDeliveryTimeParseFailure(),
      GraphQlErrorType.getCatalogItemError => GetDeliveryTimeFailure(),
      GraphQlErrorType.getCatalogItemParseError => GetDeliveryTimeParseFailure(),
      GraphQlErrorType.cartError => GetDeliveryTimeFailure(),
      GraphQlErrorType.cartParseError => GetDeliveryTimeParseFailure(),
      GraphQlErrorType.cartItemError => GetDeliveryTimeFailure(),
      GraphQlErrorType.cartItemParseError => GetDeliveryTimeParseFailure(),
      GraphQlErrorType.deliveryError => GetDeliveryTimeFailure(),
      GraphQlErrorType.deliveryParseError => GetDeliveryTimeParseFailure(),
      GraphQlErrorType.paymentError => GetDeliveryTimeFailure(),
      GraphQlErrorType.paymentParseError => GetDeliveryTimeParseFailure(),
    };
  }
}
