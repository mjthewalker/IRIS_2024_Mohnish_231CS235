import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth.bloc_states.dart';
part 'auth_bloc_events.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc() : super(AuthInitialLogin()) {
    on<AppStarted>(_onAppStarted);
    on<AuthLoginRequested>(_requestLogin);
    on<AuthSignupRequested>(_requestSignup);
    on<AuthLoginSwitch>(_switchToLogin);
    on<AuthSignupSwitch>(_switchToSignup);
    on<AuthLogout>(_logOut);
  }
  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      emit(AuthSuccess());
    } else {
      emit(AuthInitialLogin());
    }
  }
  void _requestLogin(
      AuthLoginRequested event,
      Emitter<AuthState> emit
  ) async{
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(AuthSuccess());

    }  catch (e) {
      emit(AuthFailureLogin(message: e.toString()));
    }


  }
  void _requestSignup(AuthSignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: event.email, password: event.pswd);
      await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
        'email' : event.email,
        'pswd' : event.pswd,
        'name' :  event.name,
        'roll' : event.roll,
        'role' : "student",
        'uid'  : userCredentials.user!.uid
      });


      emit(AuthSuccess());
    } catch (e) {

      emit(AuthFailureRegister(message: e.toString()));
    }
  }

  void _switchToLogin(AuthLoginSwitch event, Emitter<AuthState> emit) {

    emit(AuthInitialLogin());
  }

  void _switchToSignup(AuthSignupSwitch event, Emitter<AuthState> emit) {
    emit(AuthInitialRegister());
  }

  void _logOut(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.signOut();
      emit(AuthInitialLogin());
    } catch (e) {
      emit(AuthFailureLogin(message: 'Logout failed. Please try again.'));
    }
  }
}


