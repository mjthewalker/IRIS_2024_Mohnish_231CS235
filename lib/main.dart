import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iris_rec/Data%20and%20models/hostel_data.dart';
import 'package:iris_rec/Data%20and%20models/loading_screen.dart';
import 'package:iris_rec/Screens/Authorisation/bloc/auth_bloc.dart';
import 'package:iris_rec/Screens/Hostel_Dashboard/iris.dart';
import 'package:iris_rec/Screens/Hostel_Manager/add_hostel.dart';


import 'Data and models/firebase_options.dart';
import 'Screens/Authorisation/auth.dart';
import 'Screens/Hostel_Dashboard/bloc/iris_bloc.dart';

import 'Screens/Hostel_Manager/hostel_info.dart';
import 'Screens/Hostel_Manager/hostel_manager.dart';
import 'Screens/Hostel_change/hostel_change.dart';
import 'Screens/Hostel_registration/hostelscreen.dart';
import 'Screens/Student Leaves/manage_leaves.dart';
import 'Screens/Student_Manager/student_manager.dart';
import 'Screens/room_switch/approve_switch.dart';

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

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
          routes: {
            '/': (context) =>  const MainScaffold(),
            '/manageLeaves': (context) => const ManageLeaves(),
            '/hostelChangeApproval': (context) => const HostelChangeApproval(),
            '/hostelManager': (context) => const HostelManager(),
            '/studentManager': (context) => const StudentManager(),
            '/approveSwitch': (context) => const ApproveSwitch(),
            '/addHostel': (context) => const HostelLayoutForm(),
            // Use a function to handle parameterized routes
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/hostelInfo') {
              final args = settings.arguments as Map<String, dynamic>;
              final hostelName = args['hostelName'] as String;
              final hostelBox = args['hostelBox'] as Box;
              return MaterialPageRoute(
                builder: (context) => HostelInfo(
                  hostelName: hostelName,
                  hostelBox: hostelBox,
                ),
              );
            }
            else if (settings.name == '/hostelDetail') {
              final args = settings.arguments as Map<String, dynamic>;
              final hostel = args['hostel'];
              final mode = args['mode'];
              final currentDetails = args['currentDetails'];
              final name = args['name'];
              final roll = args['roll'];
              final studentDetail = args['studentdetail'];
              return MaterialPageRoute(
                builder: (context) => HostelDetailScreen(
                  hostel: hostel,
                  mode: mode,
                  currentDetails: currentDetails,
                  name: name,
                  roll: roll,
                  studentdetail: studentDetail,
                ),
              );
            }
            return null; // Handle other routes or return a default route
          },
      )
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
          } else if (state is AuthFailureRegister) {
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
            return LinearLoadingScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
