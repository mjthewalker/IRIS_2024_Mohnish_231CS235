import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/drawer/gf_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Data%20and%20models/student_list_model.dart';
import 'package:iris_rec/Screens/Hostel_Dashboard/my_drawer.dart';
import 'package:iris_rec/Screens/Hostel_Manager/hostel_manager.dart';
import 'package:iris_rec/Screens/Hostel_change/hostel_change.dart';
import 'package:iris_rec/Screens/Hostel_registration/hostelreg.dart';
import 'package:iris_rec/Screens/Hostel_Dashboard/my_requests.dart';
import 'package:iris_rec/Screens/Student%20Leaves/apply_leave.dart';
import 'package:iris_rec/Screens/Student%20Leaves/manage_leaves.dart';
import 'package:iris_rec/Screens/Student_Manager/student_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? userData; // To store user data
  bool isLoading = true; // Loading state for the data

  final StudentList x = StudentList(
    hostelinfo: HostelDetails(
      floor: "0",
      hostelName: "dummy hostel",
      roomNumber: "1",
      wing: "dummywing",
    ),
    email: "dummyemail",
    name: "dummyname",
    rollnumber: "dummyrolenumber",
    uid: "dummyuid",
  );

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the widget is initialized
  }

  // Function to fetch user data from Firestore
  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>; // Store user data
          isLoading = false; // Set loading to false once data is fetched
        });
      } else {
        print("No user data found for this ID.");
        setState(() => isLoading = false); // Handle no data case
      }
    } catch (e) {
      print("Error retrieving user data: $e");
      setState(() => isLoading = false); // Handle error case
    }
  }
  Widget build(BuildContext context) {
    // Get the current user's ID
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final StudentList x = StudentList(
      hostelinfo: HostelDetails(
        floor: "0",
        hostelName: "dummy hostel",
        roomNumber: "1",
        wing: "dummywing",
      ),
      email: "dummyemail",
      name: "dummyname",
      rollnumber: "dummyrolenumber",
      uid: "dummyuid",
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title:  Text(
          "HOSTEL DASHBOARD",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),

        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(
        onSignOut: () => FirebaseAuth.instance.signOut(),
        myRequests: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManageLeaves()),
          );
        },
        hostelRequests: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HostelChangeApproval()),
          );
        },
        hostelManager: (){Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HostelManager()),
        );},
        studentManager: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentManager()),
          );
        },
        isAdmin: userData?['role'],
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
            return HostelRegistrationScreen(mode: "register", studentdetail: x); // Navigate to registration screen
          }

          // Extract user data
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var name = userData['name'] ?? 'No name provided';
          var email = userData['email'] ?? 'No email provided';
          var rollNumber = userData['roll'] ?? 'No roll number';
          var hostelInfo = userData['hostelInfo']; // Hostel info (could be null)

          // Conditional UI based on hostel info
          if (hostelInfo == null) {
            return HostelRegistrationScreen(mode: "register", studentdetail: x); // Navigate to registration screen
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section with Avatar
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[400],
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            email,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Hostel Information Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Hostel Information',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildInfoRow('Hostel Name', hostelInfo['hostelName']),
                          _buildInfoRow('Room Number', hostelInfo['roomNumber']),
                          _buildInfoRow('Floor', hostelInfo['floor']),
                          _buildInfoRow('Wing', hostelInfo['wing']),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Action Buttons displayed in a grid
                  GridView.count(
                    crossAxisCount: 2, // Number of columns
                    shrinkWrap: true,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.5, // Adjust the ratio to control button height
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildActionButton(
                        icon: Icons.swap_horiz,
                        label: 'Change Hostel',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HostelRegistrationScreen(
                                mode: "change",
                                currentDetails: hostelInfo,
                                name: name,
                                rollNumber: rollNumber,
                                studentdetail: x,
                              ),
                            ),
                          );
                        },
                      ),

                      _buildActionButton(
                        icon: Icons.airplane_ticket,
                        label: 'My Requests',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyRequestsScreen(mykey: email.split('.').first,hostel: hostelInfo['hostelName'],rollnumber: rollNumber,)),
                          );
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.airplane_ticket,
                        label: 'Apply for Leave',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplyLeave(
                                hostelName: hostelInfo['hostelName'],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper widget to create information rows
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to create action buttons
  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900],
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
