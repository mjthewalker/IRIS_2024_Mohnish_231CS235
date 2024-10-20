import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iris_rec/Screens/Hostel_Manager/hostel_manager.dart';
import 'package:iris_rec/Screens/Hostel_change/hostel_change.dart';
import 'package:iris_rec/Screens/Hostel_registration/hostelreg.dart';
import 'package:iris_rec/Data%20and%20models/common_card.dart';

import 'package:iris_rec/Screens/Hostel_registration/hostelscreen.dart';
import 'package:iris_rec/Screens/Hostel_Dashboard/my_requests.dart';
import 'package:iris_rec/Screens/Student_Manager/student_manager.dart';
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("IRIS DASHBOARD"),
        backgroundColor: Colors.grey[300],
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut(); // Sign out the user
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(), // Listen for user document changes
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!')); // Error handling
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data found.')); // No user data found
          }

          // Extract user data
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var name = userData['name'] ?? 'No name provided';
          var email = userData['email'] ?? 'No email provided';
          var rollNumber = userData['roll'] ?? 'No roll number';
          var hostelInfo = userData['hostelInfo']; // Hostel info (could be null)

          // Conditional UI based on hostel info
          if (hostelInfo == null) {
            return HostelRegistrationScreen(mode : "register"); // Navigate to registration screen
          }

          // Display user information if hostel info exists
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $name', style: const TextStyle(fontSize: 18)),
                Text('Email: $email', style: const TextStyle(fontSize: 18)),
                Text('Roll Number: $rollNumber', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                const Text('Current Hostel Information:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Hostel Name: ${hostelInfo['hostelName']}', style: const TextStyle(fontSize: 16)),
                Text('Room Number: ${hostelInfo['roomNumber']}', style: const TextStyle(fontSize: 16)),
                Text('Floor: ${hostelInfo['floor']}', style: const TextStyle(fontSize: 16)),
                Text('Wing: ${hostelInfo['wing']}', style: const TextStyle(fontSize: 16)),
                TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HostelRegistrationScreen(mode : "change",currentDetails: hostelInfo,name: name,rollNumber: rollNumber,)),
                  );
                }, child: Text("Change hostel")),
                if (userData['role'] == "admin")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HostelChangeApproval()),
                                );
                                },
                                   child: Text('Hostel Change Requests'),
                                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HostelManager()),
                                  );
                                },
                                child: Text("Hostel Manager")),
                            TextButton(onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StudentManager()),
                              );
                            }, child: Text("Student Manager")),
                          ],
                        ),

                  TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyRequestsScreen(mykey: email.split('.').first,)),
                        );
                      },
                      child: Text("My requests")),


              ],
            ),
          );
        },
      ),
    );
  }
}

