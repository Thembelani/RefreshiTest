import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refreshi_test/presentation/state/bloc/auth/auth_bloc.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

void main() {
  late AuthBloc bloc;

  setUp(() {
    bloc = AuthBloc();
  });

  tearDown(() async {
    await bloc.close();
  });

  test('starts with empty credentials and none status', () {
    expect(bloc.state, const AuthState());
  });

  test('setEmail updates email', () async {
    bloc.add(const AuthEvent.setEmail(email: 'a@b.com'));
    await pumpEventQueue();

    expect(bloc.state, const AuthState(email: 'a@b.com'));
  });

  test('setPassword updates password', () async {
    bloc.add(const AuthEvent.setPassword(email: 'secret'));
    await pumpEventQueue();

    expect(bloc.state, const AuthState(password: 'secret'));
  });

  test('signIn emits loading then success after 2 seconds', () {
    fakeAsync((async) {
      final bloc = AuthBloc();
      final states = <AuthState>[];
      bloc.stream.listen(states.add);

      bloc.add(const AuthEvent.signIn());
      async.flushMicrotasks();
      expect(states, [const AuthState(status: DataStatus.loading)]);

      async.elapse(const Duration(seconds: 2));
      expect(states.last, const AuthState(status: DataStatus.success));

      bloc.close();
      async.flushMicrotasks();
    });
  });

  test('signOut emits loading then success and clears credentials', () {
    fakeAsync((async) {
      final bloc = AuthBloc();
      final states = <AuthState>[];
      bloc.stream.listen(states.add);

      bloc.add(const AuthEvent.setEmail(email: 'a@b.com'));
      bloc.add(const AuthEvent.setPassword(email: 'secret'));
      async.flushMicrotasks();

      bloc.add(const AuthEvent.signOut());
      async.flushMicrotasks();
      expect(
        states.last,
        const AuthState(
          email: 'a@b.com',
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
