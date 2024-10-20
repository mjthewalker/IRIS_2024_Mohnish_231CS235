import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_rec/Data%20and%20models/hostel_change_model.dart';

class MyRequestsScreen extends StatelessWidget {
  final String mykey;
  const MyRequestsScreen({Key? key,required this.mykey}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Requests"),
      ),
      body: FutureBuilder<List<HostelChangeRequest>>(
        future: getAllRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error handling
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Requests Found')); // No requests found
          }

          List<HostelChangeRequest> requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              HostelChangeRequest request = requests[index];

              return GestureDetector(
                onTap: () {
                  // Action on tap (you can navigate to another screen with more details)
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Hostel Change Request'),
                    subtitle: Text(
                        'Current Hostel: ${request.hostelChangeDetails.currentDetails.currentHostel}\n'
                            'New Hostel: ${request.hostelChangeDetails.newRoomDetails.newHostel}'
                    ),
                    trailing: Text('Status: ${request.status}'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
