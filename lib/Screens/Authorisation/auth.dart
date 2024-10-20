import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../Data and models/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firebase =  FirebaseAuth.instance;
class AuthScreen extends StatefulWidget{
  const AuthScreen ({super.key});
  @override
  State<StatefulWidget> createState(){
    return _AuthScreenState();
  }
}
class _AuthScreenState extends State<AuthScreen>{
  final _formkey = GlobalKey<FormState>();
  var _islogin = true;
  var _enteredemail = '';
  var _enteredpswd = '';
  var _enteredrollno = '';
  var _enteredname = '';
  void _submit() async {
    final _isValid = _formkey.currentState!.validate();
    if (!_isValid){
      return;
    }
    _formkey.currentState!.save();
    if (_islogin){
        try {
          final userCredentials = await _firebase.signInWithEmailAndPassword(
              email: _enteredemail, password: _enteredpswd);
          print(userCredentials);
        }
        on FirebaseAuthException catch (error){
          if (error.code == 'email-already-in-use'){

          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Authentication failed')),
          );
        }

      }
      else{
        try {
          final userCredentials = await _firebase
              .createUserWithEmailAndPassword(
              email: _enteredemail, password: _enteredpswd);
          await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
            'email' : _enteredemail,
            'pswd' : _enteredpswd,
            'name' : _enteredname,
            'roll' : _enteredrollno,
            'role' : "student",
            'uid'  : userCredentials.user!.uid
          });

        }
        on FirebaseAuthException catch (error){
          if (error.code == 'email-already-in-use'){

          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Authentication failed')),
          );
        }

      }





  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 10,
                    bottom : 0,
                    left : 5,
                    right : 20
                ),
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
                            validator: (value){
                              if (value == null || value.trim().isEmpty || !value.contains('@')){
                                return 'Please Enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value){
                              _enteredemail = value!;
                            },

                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password'
                            ),
                            obscureText: true,
                            cursorColor: Colors.grey[700],
                            validator: (value){
                              if (value == null || value.trim().isEmpty || value.trim().length<6){
                                return 'Please Enter a valid password';
                              }
                              return null;
                            },
                            onSaved: (value){
                              _enteredpswd = value!;
                            },
                          ),
                          const SizedBox(height: 10,),
                          if (!_islogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                              cursorColor: Colors.grey[700],
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (value){
                                _enteredname = value!;
                              },

                            ),
                          if (!_islogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Roll Number',
                              ),
                              cursorColor: Colors.grey[700],
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (value){
                                _enteredrollno = value!;
                              },

                            ),

                        ],
                      ),

                    ),
                  ),
                ),
              ),

                    TextButton(onPressed: (){
                      setState(() {
                        _islogin = !_islogin;
                      });
                    }, child: Text( _islogin ? 'No account?, register here!!!':'I already have an account. Login.',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),)),

              const SizedBox( height : 20),
              GestureDetector(
                onTap: _submit,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Center(
                    child: Text( _islogin ?'Login' : 'Signup',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16 ,
                      ),
                    ),
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}