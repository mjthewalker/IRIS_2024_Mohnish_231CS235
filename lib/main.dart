import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iris_rec/Screens/Authorisation/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iris_rec/Data%20and%20models/hostel_data.dart';
import 'Data and models/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_rec/Screens/Hostel_Dashboard/iris.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iris_rec/Screens/Hostel_registration/hostelreg.dart';
import 'package:iris_rec/Screens/Hostel_registration/hostelscreen.dart';

import 'firebase_api/firebase_api.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();


  // Open a box for hostel data

  // Register adapters before opening the box
  Hive.registerAdapter(WingAdapter());
  Hive.registerAdapter(FloorAdapter());
  Hive.registerAdapter(HostelAdapter());
  var hostelBox = await Hive.openBox<Hostel>('hostelBox6');


   // Be careful with this; it deletes all data in the box.

  // Initialize your database with the opened box
  HostelDataBase hostelDataBase = HostelDataBase(hostelBox);
  await hostelDataBase.storeHostelDataOnce();
  await hostelDataBase.printAllHostels();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();

  runApp(
    MaterialApp(

      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return MainScreen();
          }
          return const AuthScreen();
        },
      ),
    ),
  );
}


