class BaseGraphError {
  final String? message;
  final Object? error;
  final StackTrace? stackTrace;
  final GraphQlErrorType type;
  BaseGraphError({
    required this.type,
    this.message,
    this.error,
    this.stackTrace,
  });
}

enum GraphQlErrorType {
  getCatalogItemError,
  getCatalogItemParseError,
  cartError,
  cartParseError,
  cartItemError,
  cartItemParseError,
  deliveryError,
  deliveryParseError,
  paymentError,
  paymentParseError,
  deliveryTimeError,
  deliveryTimeParseError,
}
