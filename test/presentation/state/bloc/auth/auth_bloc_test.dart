import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/application/use_cases/auth/sign_in_use_case.dart';
import 'package:refreshi_test/domain/failures/auth_failures.dart';
import 'package:refreshi_test/presentation/state/bloc/auth/auth_bloc.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

import '../../../../mocks.dart';

void main() {
  late MockSignInUseCase signInUseCase;
  late AuthBloc bloc;

  setUpAll(() {
    registerFallbackValue(const SignInParams(email: '', password: ''));
  });

  setUp(() {
    signInUseCase = MockSignInUseCase();
    when(
      () => signInUseCase.call(any()),
    ).thenReturn(TaskEither.right(unit));
    bloc = AuthBloc(signInUseCase);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('starts with empty credentials and none status', () {
    expect(bloc.state, const AuthState());
  });

  test('setEmail updates email', () async {
    bloc.add(const AuthEvent.setEmail(email: 'test@user.com'));
    await pumpEventQueue();

    expect(bloc.state, const AuthState(email: 'test@user.com'));
  });

  test('setPassword updates password', () async {
    bloc.add(const AuthEvent.setPassword(email: 'secret'));
    await pumpEventQueue();

    expect(bloc.state, const AuthState(password: 'secret'));
  });

  test('signIn emits loading then success after 2 seconds', () {
    fakeAsync((async) {
      final useCase = MockSignInUseCase();
      when(() => useCase.call(any())).thenReturn(TaskEither.right(unit));
      final bloc = AuthBloc(useCase);
      final states = <AuthState>[];
      bloc.stream.listen(states.add);

      bloc.add(const AuthEvent.setEmail(email: 'test@user.com'));
      bloc.add(const AuthEvent.setPassword(email: 'Test1234'));
      async.flushMicrotasks();

      bloc.add(const AuthEvent.signIn());
      async.flushMicrotasks();
      expect(
        states.last,
        const AuthState(
          email: 'test@user.com',
          password: 'Test1234',
          status: DataStatus.loading,
        ),
      );

      async.elapse(const Duration(seconds: 2));
      expect(
        states.last,
        const AuthState(
          email: 'test@user.com',
          password: 'Test1234',
          status: DataStatus.success,
          isLoggedIn: true,
        ),
      );

      bloc.close();
      async.flushMicrotasks();
    });
  });

  test('signIn emits error when the use case fails', () async {
    final failure = InvalidEmailFailure();
    when(
      () => signInUseCase.call(any()),
    ).thenReturn(TaskEither.left(failure));

    bloc.add(const AuthEvent.signIn());
    await pumpEventQueue();

    expect(
      bloc.state,
      AuthState(status: DataStatus.error, failure: failure),
    );
  });

  test('signOut emits loading then success and clears credentials', () {
    fakeAsync((async) {
      final useCase = MockSignInUseCase();
      when(() => useCase.call(any())).thenReturn(TaskEither.right(unit));
      final bloc = AuthBloc(useCase);
      final states = <AuthState>[];
      bloc.stream.listen(states.add);

      bloc.add(const AuthEvent.setEmail(email: 'test@user.com'));
      bloc.add(const AuthEvent.setPassword(email: 'secret'));
      async.flushMicrotasks();

      bloc.add(const AuthEvent.signOut());
      async.flushMicrotasks();
      expect(
        states.last,
        const AuthState(
          email: 'test@user.com',
          password: 'secret',
          status: DataStatus.loading,
        ),
      );

      async.elapse(const Duration(seconds: 2));
      expect(states.last, const AuthState(status: DataStatus.success));

      bloc.close();
      async.flushMicrotasks();
    });
  });
}
