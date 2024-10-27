import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Data%20and%20models/student_list_model.dart';
import 'package:iris_rec/Screens/Authorisation/bloc/auth_bloc.dart';
import 'package:iris_rec/Screens/Hostel_Dashboard/my_drawer.dart';
import 'package:iris_rec/Screens/room_switch/approve_switch.dart';
import 'package:iris_rec/Screens/room_switch/switch_rooms.dart';
import 'package:iris_rec/Screens/Hostel_Manager/hostel_manager.dart';
import 'package:iris_rec/Screens/Hostel_change/hostel_change.dart';
import 'package:iris_rec/Screens/Hostel_registration/hostelreg.dart';
import 'package:iris_rec/Screens/Hostel_Dashboard/my_requests.dart';
import 'package:iris_rec/Screens/Student%20Leaves/apply_leave.dart';
import 'package:iris_rec/Screens/Student%20Leaves/manage_leaves.dart';
import 'package:iris_rec/Screens/Student_Manager/student_manager.dart';

import '../../Data and models/loading_screen.dart';
import 'bloc/iris_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    context.read<HomeBloc>().add(LoadData());
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return  Scaffold(
            body: LinearLoadingScreen(),
          );
        } else if (state is HomeError) {
          return Scaffold(
            body: Center(child: Text(state.error)),
          );
        } else if (state is HomeLoadedWithoutData) {
          return HostelRegistrationScreen(
            mode: "register",
            studentdetail: x,
          );
        } else if (state is HomeLoadedWithData) {
          final userData = state.userData;
          final name = userData['name'] ?? 'No name provided';
          final email = userData['email'] ?? 'No email provided';
          final rollNumber = userData['roll'] ?? 'No roll number';
          final hostelInfo = userData['hostelInfo'];

          final StudentList y = StudentList(
            hostelinfo: HostelDetails(
              floor: hostelInfo['floor'],
              hostelName: hostelInfo['hostelName'],
              roomNumber: hostelInfo['roomNumber'],
              wing: hostelInfo['wing'],
            ),
            email: email,
            name: name,
            rollnumber: rollNumber,
            uid: userId,
          );

          return Scaffold(
            backgroundColor: Colors.grey[850],
            appBar: AppBar(
              title: Text(
                "HOSTEL DASHBOARD",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.grey[900],
              iconTheme: const IconThemeData(color: Colors.tealAccent),
              elevation: 2,
            ),
            drawer: MyDrawer(
              onSignOut: () {
                context.read<AuthBloc>().add(AuthLogout());
              },
              myRequests: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageLeaves()),
                );
              },
              hostelRequests: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HostelChangeApproval()),
                );
              },
              hostelManager: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HostelManager()),
                );
              },
              studentManager: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentManager()),
                );
              },
              switchRequests: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApproveSwitch()),
                );
              },
              isAdmin: userData['role'],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[400],
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.tealAccent,
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
                                color: Colors.tealAccent,
                              ),
                            ),
                            Text(
                              email,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.blueGrey[800],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hostel Room Details',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.tealAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow('Hostel', hostelInfo['hostelName']),
                            _buildInfoRow('Room Number', hostelInfo['roomNumber']),
                            _buildInfoRow('Floor', hostelInfo['floor']),
                            _buildInfoRow('Wing', hostelInfo['wing']),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildActionButton(
                          icon: Icons.swap_vert,
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
                          icon: Icons.question_answer_rounded,
                          label: 'My Requests',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyRequestsScreen(
                                  mykey: email.split('.').first,
                                  hostel: hostelInfo['hostelName'],
                                  rollnumber: rollNumber,
                                ),
                              ),
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
                        _buildActionButton(
                          icon: Icons.swap_horiz,
                          label: 'Switch Rooms',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SwitchRooms(studentinfo: y),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Center(child: Text('No data available'));
      },
    );
  }

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
              color: Colors.tealAccent,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900],
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, color: Colors.tealAccent),
      label: Text(
        label,
        style: GoogleFonts.poppins(color: Colors.tealAccent),
      ),
      onPressed: onPressed,
    );
  }
}
