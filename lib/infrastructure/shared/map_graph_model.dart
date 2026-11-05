import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';

class GraphModelMapper {
  static TaskEither<BaseGraphError, T> mapCreate<T, M>(
    M model, {
    required AutoMapprInterface mapper,
    required GraphQlErrorType parseErrorType,
  }) {
    return _tryMap<T>(
      () => mapper.convert<M, T>(model),
      parseErrorType: parseErrorType,
    );
  }

  static TaskEither<BaseGraphError, T> mapGet<T, M>(
    M model, {
    required AutoMapprInterface mapper,
    required GraphQlErrorType parseErrorType,
  }) {
    return _tryMap<T>(
      () => mapper.convert<M, T>(model),
      parseErrorType: parseErrorType,
    );
  }

  static TaskEither<BaseGraphError, T> mapListItem<T, M>(
    M model, {
    required AutoMapprInterface mapper,
    required GraphQlErrorType parseErrorType,
  }) {
    return _tryMap<T>(
      () => mapper.convert<M, T>(model),
      parseErrorType: parseErrorType,
    );
  }

  static TaskEither<BaseGraphError, T> mapUpdate<T, M>(
    M model, {
    required AutoMapprInterface mapper,
    required GraphQlErrorType parseErrorType,
  }) {
    return _tryMap<T>(
      () => mapper.convert<M, T>(model),
      parseErrorType: parseErrorType,
    );
  }

  static TaskEither<BaseGraphError, T> _tryMap<T>(
    T Function() map, {
    required GraphQlErrorType parseErrorType,
  }) {
    return TaskEither.tryCatch(
      () => Future.sync(map),
      (Object error, StackTrace stackTrace) => BaseGraphError(
        type: parseErrorType,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }
}
