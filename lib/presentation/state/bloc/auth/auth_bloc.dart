import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/auth/sign_in_use_case.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._signInUseCase) : super(const AuthState()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        setEmail: (email) => _setEmail(emit, email),
        setPassword: (password) => _setPassword(emit, password),
        signIn: () => _signIn(emit),
        signOut: () => _signOut(emit),
      );
    });
  }

  final SignInUseCase _signInUseCase;

  Future<void> _setEmail(Emitter<AuthState> emit, String? email) async {
    emit(state.copyWith(email: email));
  }

  Future<void> _setPassword(Emitter<AuthState> emit, String? password) async {
    emit(state.copyWith(password: password));
  }

  Future<void> _signIn(Emitter<AuthState> emit) async {
    emit(state.copyWith(status: DataStatus.loading, failure: null));
    final result = await _signInUseCase
        .call(
          SignInParams(
            email: state.email ?? '',
            password: state.password ?? '',
          ),
        )
        .run();

    final failure = result.fold<BaseFailure?>((value) => value, (_) => null);
    if (failure != null) {
      emit(state.copyWith(status: DataStatus.error, failure: failure));
      return;
    }

    await Future.delayed(const Duration(seconds: 2));
    emit(
      state.copyWith(
        status: DataStatus.success,
        failure: null,
        isLoggedIn: true,
      ),
    );
  }

  Future<void> _signOut(Emitter<AuthState> emit) async {
    emit(state.copyWith(status: DataStatus.loading, failure: null));
    await Future.delayed(const Duration(seconds: 2));
    emit(
      state.copyWith(
        status: DataStatus.success,
        email: null,
        password: null,
        failure: null,
        isLoggedIn: false,
      ),
    );
  }
}
