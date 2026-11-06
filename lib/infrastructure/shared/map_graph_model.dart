import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';

class GraphModelMapper {
  static TaskEither<BaseGraphError, Target> mapCreate<Source, Target>(
    Source model, {
    required AutoMapprInterface mapper,
    required GraphQlErrorType parseErrorType,
  }) {
    return _tryMap<Target>(
      () => mapper.convert<Source, Target>(model),
      parseErrorType: parseErrorType,
    );
  }

  static TaskEither<BaseGraphError, Target> mapGet<Source, Target >(
    Source model, {
    required AutoMapprInterface mapper,
    required GraphQlErrorType parseErrorType,
  }) {
    return _tryMap<Target>(
      () => mapper.convert<Source, Target>(model),
      parseErrorType: parseErrorType,
    );
  }

  static TaskEither<BaseGraphError, Target> mapListItem<Source, Target>(
    Source model, {
    required AutoMapprInterface mapper,
    required GraphQlErrorType parseErrorType,
  }) {
    return _tryMap<Target>(
      () => mapper.convert<Source, Target>(model),
      parseErrorType: parseErrorType,
    );
  }

  static TaskEither<BaseGraphError, Target> mapUpdate<Source, Target>(
    Source model, {
    required AutoMapprInterface mapper,
    required GraphQlErrorType parseErrorType,
  }) {
    return _tryMap<Target>(
      () => mapper.convert<Source, Target>(model),
      parseErrorType: parseErrorType,
    );
  }

  static TaskEither<BaseGraphError, Target> _tryMap<Target>(
    Target Function() map, {
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
