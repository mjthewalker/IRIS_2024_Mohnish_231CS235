import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iris_rec/Data%20and%20models/hostel_data.dart';
import 'package:iris_rec/Screens/Authorisation/bloc/auth_bloc.dart';
import 'package:iris_rec/Screens/Hostel_Dashboard/iris.dart';


import '../../Data and models/firebase_options.dart';
import '../Authorisation/auth.dart';
import '../Hostel_Dashboard/bloc/iris_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WingAdapter());
  Hive.registerAdapter(FloorAdapter());
  Hive.registerAdapter(HostelAdapter());
  var hostelBox = await Hive.openBox<Hostel>('hostelBox6');
  HostelDataBase hostelDataBase = HostelDataBase(hostelBox);
  await hostelDataBase.storeHostelDataOnce();
  await hostelDataBase.printAllHostels();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AppStarted()),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(LoadData()),
        ),



      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScaffold(),
      ),
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureLogin) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<AuthBloc>().add(AuthLoginSwitch());
          }
          else if (state is AuthFailureRegister) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<AuthBloc>().add(AuthSignupSwitch());
          }
        },
        builder: (context, state) {
          if (state is AuthSuccess) {
            return const MainScreen();
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
