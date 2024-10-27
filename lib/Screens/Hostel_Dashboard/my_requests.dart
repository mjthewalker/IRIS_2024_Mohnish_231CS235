import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Data and models/hostel_change_model.dart';
import 'package:iris_rec/Data%20and%20models/loading_screen.dart';

class MyRequestsScreen extends StatelessWidget {
  final String mykey;
  final String hostel;
  final String rollnumber;

  const MyRequestsScreen({
    super.key,
    required this.mykey,
    required this.hostel,
    required this.rollnumber,
  });

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
        if (userData != null && userData is Map<String, dynamic> ) {
          print(data);
          requests.add(data);
        }
      });
    }
    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Requests",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
        elevation: 2,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([getAllRequests(), leaveRequests()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearLoadingScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Requests Found'));
          }

          List<HostelChangeRequest> hostelRequests = snapshot.data![0] as List<HostelChangeRequest>;
          List<Map<String, dynamic>> leaveRequestsData = snapshot.data![1] as List<Map<String, dynamic>>;

          List<Widget> combinedRequests = [];

          combinedRequests.addAll(hostelRequests.map((request) {
            return Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              color: Colors.grey[900],
              child: ListTile(
                leading: const Icon(Icons.home_outlined, color: Colors.tealAccent),
                title: Text(
                  "Hostel Change Request",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
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
                      color: Colors.white70,
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
                        : request.status == 'Denied' ? Colors.redAccent : Colors.orangeAccent,
                  ),
                ),
              ),
            );
          }));

          combinedRequests.add(Divider(
            height: 20,
            thickness: 1.5,
            color: Colors.tealAccent.withOpacity(0.5),
            indent: 20,
            endIndent: 20,
          ));

          combinedRequests.addAll(leaveRequestsData.map((leaveRequest) {
            final requestData = leaveRequest[rollnumber];
            final hasReason = requestData != null && requestData.containsKey('Reason');
            final hasStatus = requestData != null && requestData.containsKey('status');

            return Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              color: Colors.grey[900],
              child: ListTile(
                leading: const Icon(Icons.airplane_ticket_outlined, color: Colors.tealAccent),
                title: Text(
                  "Leave Request",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    hasReason ? 'Reason: ${requestData['Reason']}' : 'Reason: Not available',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ),
                trailing: Text(
                  hasStatus ? "Status: ${requestData['status']}" : "Status: Unknown",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: hasStatus && requestData['status'] == 'Approved'
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
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
