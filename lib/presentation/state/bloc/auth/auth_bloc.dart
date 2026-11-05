import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        setEmail: (email) => _setEmail(emit, email),
        setPassword: (password) => _setPassword(emit, password),
        signIn: () => _signIn(emit),
        signOut: () => _signOut(emit)
      );
    });
  }

  Future<void> _setEmail(
    Emitter<AuthState> emit,
    String? email,

  ) async {
    emit(state.copyWith(email: email));
  }

  Future<void> _setPassword(
    Emitter<AuthState> emit,
    String? password,
  ) async {
    emit(state.copyWith(password: password));
  }

  Future<void> _signIn(
     Emitter<AuthState> emit
  ) async {
    emit(state.copyWith(status: DataStatus.loading));
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith( status: DataStatus.success));
  }

  Future<void> _signOut(
     Emitter<AuthState> emit
  ) async {
    emit(state.copyWith(status: DataStatus.loading));
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(status: DataStatus.success, email: null, password: null));
  }
}

