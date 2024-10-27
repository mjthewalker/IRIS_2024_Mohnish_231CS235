part of 'auth_bloc.dart';

@immutable

sealed class AuthState {}



class AuthInitialLogin extends AuthState {}

class AuthInitialRegister  extends AuthState {}

class AuthSuccess  extends AuthState {}

class AuthFailureLogin  extends AuthState {
  final String message;

  AuthFailureLogin({required this.message});
}

class AuthFailureRegister  extends AuthState {
  final String message;

  AuthFailureRegister({required this.message});
}

class AuthLoading extends AuthState{}
