import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

        // Iterate through each user's request data
        requestData.forEach((userKey, userData) {
          if (userData is Map<String, dynamic> && userKey == mykey) {
            // Create a HostelChangeRequest object from each user's data
            HostelChangeRequest request = HostelChangeRequest.fromJson(userData);
            allRequests.add(request);
          }
        });
      }
    } catch (e) {
      print("Error fetching requests: $e"); // Log the error
    }

    return allRequests;
  }

  Future<List<Map<String, dynamic>>> leaveRequests() async {
    List<Map<String, dynamic>> requests = [];
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('leaves').doc(hostel).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data.forEach((userKey, userData) {
        // Check if userData is a valid map and not empty
        if (userData != null && userData is Map<String, dynamic>) {
          // Only add to allRequests if the required fields are present

          requests.add(data);

        } else {
          print("userData is null or not a valid map for user: $userKey");
        }
      });
    }
    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Requests"),
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
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: const Text('Hostel Change Request'),
                subtitle: Text(
                  'Current Hostel: ${request.hostelChangeDetails.currentDetails.currentHostel}\n'
                      'New Hostel: ${request.hostelChangeDetails.newRoomDetails.newHostel}',
                ),
                trailing: Text('Status: ${request.status}'),
              ),
            );
          }));

          // Add leave requests to the combined list
          combinedRequests.addAll(leaveRequestsData.map((leaveRequest) {
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: const Text('Leave Request'),
                subtitle: Text(
                  'Reason: ${leaveRequest['$rollnumber']['Reason']}\n'

                ),
                trailing: Text('Status: ${leaveRequest['$rollnumber']['status']}'),
              ),
            );
          }));

          return ListView(
            children: combinedRequests,
          );
        },
      ),
    );
  }
}
