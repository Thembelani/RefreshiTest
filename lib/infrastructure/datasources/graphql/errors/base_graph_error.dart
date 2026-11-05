class BaseGraphError {
  final String? message;
  final Object? error;
  final StackTrace? stackTrace;
  final GraphQlErrorType type;
  BaseGraphError({required this.type, this.message, this.error, this.stackTrace});
}


enum GraphQlErrorType {
  getCatalogItemError,
  getCatalogItemParseError
}