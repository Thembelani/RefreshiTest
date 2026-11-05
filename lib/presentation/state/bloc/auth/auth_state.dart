part of 'auth_bloc.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    String? email,
    String? password,
    @Default(DataStatus.none) DataStatus status,
    BaseFailure? failure,
  }) = _AuthState;
}