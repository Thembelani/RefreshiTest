import 'package:flutter_test/flutter_test.dart';
import 'package:refreshi_test/application/use_cases/auth/sign_in_use_case.dart';
import 'package:refreshi_test/domain/failures/auth_failures.dart';

void main() {
  late SignInUseCase useCase;

  setUp(() {
    useCase = SignInUseCase();
  });

  test('succeeds for a valid email and password Test1234', () async {
    final result = await useCase
        .call(
          const SignInParams(email: 'test@user.com', password: 'Test1234'),
        )
        .run();

    expect(result.isRight(), isTrue);
  });

  test('fails for an invalid email', () async {
    final result = await useCase
        .call(
          const SignInParams(email: 'a@b.com', password: 'Test1234'),
        )
        .run();

    result.fold(
      (failure) => expect(failure, isA<InvalidEmailFailure>()),
      (_) => fail('expected InvalidEmailFailure'),
    );
  });

  test('fails when password is not Test1234', () async {
    final result = await useCase
        .call(
          const SignInParams(email: 'test@user.com', password: 'secret'),
        )
        .run();

    result.fold(
      (failure) => expect(failure, isA<InvalidPasswordFailure>()),
      (_) => fail('expected InvalidPasswordFailure'),
    );
  });
}
