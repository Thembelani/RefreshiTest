import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/failures/payment_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';

extension PaymentErrorExtension on BaseGraphError {
  BaseFailure toPaymentFailure() {
    return switch (type) {
      GraphQlErrorType.paymentError => PaymentFailure(),
      GraphQlErrorType.paymentParseError => PaymentParseFailure(),
      GraphQlErrorType.getCatalogItemError => PaymentFailure(),
      GraphQlErrorType.getCatalogItemParseError => PaymentParseFailure(),
      GraphQlErrorType.cartError => PaymentFailure(),
      GraphQlErrorType.cartParseError => PaymentParseFailure(),
      GraphQlErrorType.cartItemError => PaymentFailure(),
      GraphQlErrorType.cartItemParseError => PaymentParseFailure(),
      GraphQlErrorType.deliveryError => PaymentFailure(),
      GraphQlErrorType.deliveryParseError => PaymentParseFailure(),
      GraphQlErrorType.deliveryTimeError => PaymentFailure(),
      GraphQlErrorType.deliveryTimeParseError => PaymentParseFailure(),
    };
  }
}
