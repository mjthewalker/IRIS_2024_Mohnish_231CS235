
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget{
  const AuthScreen ({super.key});
  @override
  State<StatefulWidget> createState(){
    return _AuthScreenState();
  }
}
class _AuthScreenState extends State<AuthScreen>{
  final _formkey = GlobalKey<FormState>();
  var _enteredemail = '';
  var _enteredpswd = '';
  var _enteredrollno = '';
  var _enteredname = '';
  void _submit() {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) return;
    _formkey.currentState!.save();
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthInitialLogin) {
      authBloc.add(
        AuthLoginRequested(
          email: _enteredemail,
          password: _enteredpswd,
        ),
      );
    } else if (authBloc.state is AuthInitialRegister) {
      authBloc.add(
        AuthSignupRequested(
          email: _enteredemail,
          pswd: _enteredpswd,
          name: _enteredname,
          roll: _enteredrollno,
        ),
      );
    }
  }

  void _toggleAuthMode() {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthInitialLogin) {
      authBloc.add(AuthSignupSwitch());
    } else if (authBloc.state is AuthInitialRegister) {
      authBloc.add(AuthLoginSwitch());
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailureLogin || state is AuthFailureRegister) {
          final message = state is AuthFailureLogin
              ? state.message
              : (state as AuthFailureRegister).message;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          print("EROROROOROR");
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 0, left: 5, right: 20),
                    width: 300,
                    child: Image.asset('assets/images/logo1.jpg'),
                  ),
                  Card(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                ),
                                cursorColor: Colors.grey[700],
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Please Enter a valid email address.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredemail = value!;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                                obscureText: true,
                                cursorColor: Colors.grey[700],
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.trim().length < 6) {
                                    return 'Please Enter a valid password';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredpswd = value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              if (state is AuthInitialRegister) ...[
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                  ),
                                  cursorColor: Colors.grey[700],
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  onSaved: (value) {
                                    _enteredname = value!;
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Roll Number',
                                  ),
                                  cursorColor: Colors.grey[700],
                                  keyboardType: TextInputType.number,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  onSaved: (value) {
                                    _enteredrollno = value!;
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      state is AuthInitialLogin
                          ? 'No account? Register here!'
                          : 'I already have an account. Login.',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _submit,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          state is AuthInitialLogin ? 'Login' : 'Signup',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



