part of 'auth_bloc.dart';
@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.setEmail({required String? email}) = SetEmail;
  const factory AuthEvent.setPassword({required String? email}) = SetPassword;
  const factory AuthEvent.signIn() = SignIn;
  const factory AuthEvent.signOut() = SignOut;

} 

