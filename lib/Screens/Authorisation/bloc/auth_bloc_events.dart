part of 'auth_bloc.dart';

@immutable

sealed class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
    final String email;
    final String password;
    AuthLoginRequested({required this.email,required this.password});
}

class AuthSignupRequested extends AuthEvent {
    final String name;
    final String roll;
    final String pswd;

    final String email;

    AuthSignupRequested({
        required this.email, required this.pswd, required this.roll, required this.name
    });

}
class AppStarted extends AuthEvent {}

class AuthLoginSwitch  extends AuthEvent {

}

class AuthSignupSwitch  extends AuthEvent {

}
class AuthLogout  extends AuthEvent {

}
