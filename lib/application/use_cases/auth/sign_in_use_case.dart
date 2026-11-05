import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/domain/failures/auth_failures.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

@LazySingleton()
class SignInUseCase implements UseCase<Unit, SignInParams> {
  SignInUseCase();

  static const _validEmail = 'test@user.com';
  static const _validPassword = 'Test1234';

  @override
  TaskEither<BaseFailure, Unit> call(SignInParams params) {
    if (params.email != _validEmail) {
      return TaskEither.left(InvalidEmailFailure());
    }
    if (params.password != _validPassword) {
      return TaskEither.left(InvalidPasswordFailure());
    }
    return TaskEither.right(unit);
  }
}
