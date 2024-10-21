import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Data and models/hostel_change_model.dart';
import 'package:iris_rec/Data and models/student_list_model.dart';

class MyRequestsScreen extends StatelessWidget {
  final String mykey;
  final String hostel;
  final String rollnumber;

  const MyRequestsScreen({
    Key? key,
    required this.mykey,
    required this.hostel,
    required this.rollnumber,
  }) : super(key: key);

  Future<List<HostelChangeRequest>> getAllRequests() async {
    List<HostelChangeRequest> allRequests = [];

    try {
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('requests');
      QuerySnapshot requestsSnapshot = await requestsCollection.get();

      for (var requestDoc in requestsSnapshot.docs) {
        Map<String, dynamic> requestData = requestDoc.data() as Map<String, dynamic>;

        requestData.forEach((userKey, userData) {
          if (userData is Map<String, dynamic> && userKey == mykey) {
            HostelChangeRequest request = HostelChangeRequest.fromJson(userData);
            allRequests.add(request);
          }
        });
      }
    } catch (e) {
      print("Error fetching requests: $e");
    }

    return allRequests;
  }

  Future<List<Map<String, dynamic>>> leaveRequests() async {
    List<Map<String, dynamic>> requests = [];
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('leaves').doc(hostel).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data.forEach((userKey, userData) {
        if (userData != null && userData is Map<String, dynamic>) {
          requests.add(data);
        }
      });
    }
    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850], // Dark background
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Requests",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent, // Accent color for title
          ),
        ),
        backgroundColor: Colors.grey[900], // Dark AppBar
        iconTheme: const IconThemeData(color: Colors.tealAccent),
        elevation: 2, // Subtle shadow
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([getAllRequests(), leaveRequests()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error handling
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Requests Found')); // No requests found
          }

          List<HostelChangeRequest> hostelRequests = snapshot.data![0] as List<HostelChangeRequest>;
          List<Map<String, dynamic>> leaveRequestsData = snapshot.data![1] as List<Map<String, dynamic>>;

          // Combine requests for display
          List<Widget> combinedRequests = [];

          // Add hostel change requests to the combined list
          combinedRequests.addAll(hostelRequests.map((request) {
            return Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8, // Shadow for depth
              color: Colors.grey[900], // Dark card background
              child: ListTile(
                leading: const Icon(Icons.home_outlined, color: Colors.tealAccent),
                title: Text(
                  "Hostel Change Request",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent, // Accent color for title
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Current Hostel: ${request.hostelChangeDetails.currentDetails.currentHostel}\n'
                        'New Hostel: ${request.hostelChangeDetails.newRoomDetails.newHostel}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70, // Softer text color for readability
                    ),
                  ),
                ),
                trailing: Text(
                  "Status: ${request.status}",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: request.status == 'Approved'
                        ? Colors.greenAccent
                        : request.status == 'Denied' ? Colors.redAccent :Colors.orangeAccent, // Use accent colors for status
                  ),
                ),
              ),
            );
          }));

          // Divider between different request types
          combinedRequests.add(Divider(
            height: 20,
            thickness: 1.5,
            color: Colors.tealAccent.withOpacity(0.5), // Accent color for divider
            indent: 20,
            endIndent: 20,
          ));

          // Add leave requests to the combined list
          combinedRequests.addAll(leaveRequestsData.map((leaveRequest) {
            return Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8, // Shadow for depth
              color: Colors.grey[900], // Dark card background
              child: ListTile(
                leading: const Icon(Icons.airplane_ticket_outlined, color: Colors.tealAccent),
                title: Text(
                  "Leave Request",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent, // Accent color for title
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Reason: ${leaveRequest['$rollnumber']['Reason']}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70, // Softer text color for readability
                    ),
                  ),
                ),
                trailing: Text(
                  "Status: ${leaveRequest['$rollnumber']['status']}",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: leaveRequest['$rollnumber']['status'] == 'Approved'
                        ? Colors.greenAccent
                        : Colors.orangeAccent, // Use accent colors for status
                  ),
                ),
              ),
            );
          }));

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: combinedRequests,
          );
        },
      ),
    );
  }
}
