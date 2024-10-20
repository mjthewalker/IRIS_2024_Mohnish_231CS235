import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageLeaves extends StatefulWidget {
  @override
  _ManageLeaveState createState() => _ManageLeaveState();
}

class _ManageLeaveState extends State<ManageLeaves> {
  Future<List<Map<String, dynamic>>> getAllRequests() async {
    List<Map<String, dynamic>> allRequests = [];

    try {
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('leaves');
      QuerySnapshot requestsSnapshot = await requestsCollection.get();

      for (var requestDoc in requestsSnapshot.docs) {
        Map<String, dynamic> requestData = requestDoc.data() as Map<String, dynamic>;

        // Iterate over the keys in requestData, assuming each key is a roll number or user identifier
        requestData.forEach((userKey, userData) {
          // Check if userData is a valid map and not empty
          if (userData != null && userData is Map<String, dynamic>) {
            // Only add to allRequests if the required fields are present
            allRequests.add(userData);

          } else {
            print("userData is null or not a valid map for user: $userKey");
          }
        });
      }
    } catch (e) {
      print("Error fetching requests: $e"); // Log the error
    }


    return allRequests;
  }

  // Function to update the request status in Firestore
  Future<void> updateRequestStatus(String docId, String status,String hostel) async {
    try {
      await FirebaseFirestore.instance.collection('leaves').doc(hostel).set({
          docId : {
            "status" : status
          }
      },SetOptions(merge: true));
      setState(() {}); // Refresh the UI after status change
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Manage Leaves",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error handling
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Leave Requests Found')); // No requests found
          }

          List<Map<String, dynamic>> leaveRequests = snapshot.data!;

          return ListView.builder(
            itemCount: leaveRequests.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> leaveRequest = leaveRequests[index];
              String docId = leaveRequest['rollNumber']; // Assuming each request has a unique docId
              String hostel = leaveRequest['hostel'];
              return GestureDetector(
                onTap: () {},
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: const Text('Leave Request'),
                    subtitle: Text(
                      'Reason: ${leaveRequest['Reason']}\n'
                          'From: ${leaveRequest['name']}\n'
                          'To: ${leaveRequest['rollNumber']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Status: ${leaveRequest['status']}'),
                        const SizedBox(width: 10),
                        // Approve Button
                        if (leaveRequest['status'] == 'yet to be approved')
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => updateRequestStatus(docId, 'Approved',hostel),
                        ),
                        if (leaveRequest['status'] == 'yet to be approved')
                        // Reject Button
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => updateRequestStatus(docId, 'Rejected',hostel),
                        ),
                      ],
                    ),
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
