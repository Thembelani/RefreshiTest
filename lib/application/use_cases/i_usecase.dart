import 'package:fpdart/fpdart.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';

abstract class UseCase<EntityType, Params> {
  TaskEither<BaseFailure, EntityType> call(Params params);
}
