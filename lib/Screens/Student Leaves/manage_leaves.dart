import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageLeaves extends StatefulWidget {
  @override
  _ManageLeaveState createState() => _ManageLeaveState();
}

class _ManageLeaveState extends State<ManageLeaves> {
  // Fetch all leave requests from Firestore
  Future<List<Map<String, dynamic>>> getAllRequests() async {
    List<Map<String, dynamic>> allRequests = [];

    try {
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('leaves');
      QuerySnapshot requestsSnapshot = await requestsCollection.get();

      for (var requestDoc in requestsSnapshot.docs) {
        Map<String, dynamic> requestData = requestDoc.data() as Map<String, dynamic>;

        // Iterate over user requests in the document
        requestData.forEach((userKey, userData) {
          if (userData != null && userData is Map<String, dynamic>) {
            allRequests.add(userData);
          } else {
            print("userData is null or not a valid map for user: $userKey");
          }
        });
      }
    } catch (e) {
      print("Error fetching requests: $e");
    }

    return allRequests;
  }

  // Function to update the request status in Firestore
  Future<void> updateRequestStatus(String docId, String status, String hostel) async {
    try {
      await FirebaseFirestore.instance.collection('leaves').doc(hostel).set({
        docId: {
          "status": status,
        }
      }, SetOptions(merge: true));

      // Provide user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $status')),
      );

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
            color: Colors.tealAccent, // Accent color for AppBar title
          ),
        ),
        backgroundColor: Colors.grey[900], // Dark background for AppBar
        iconTheme: const IconThemeData(color: Colors.tealAccent), // Accent for AppBar icons
        centerTitle: true,
        elevation: 2, // Subtle shadow for AppBar
      ),
      backgroundColor: Colors.grey[850], // Dark background for body
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllRequests(),
        builder: (context, snapshot) {
          // Handling different states of the Future
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

              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.grey[900], // Dark card background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners for cards
                  side: BorderSide(color: Colors.tealAccent, width: 1.5), // Accent color border
                ),
                elevation: 8, // Card elevation for shadow effect
                child: ListTile(
                  title: Text(
                    "Leave Request",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent, // Accent color for title
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason: ${leaveRequest['Reason']}\n'
                            'From: ${leaveRequest['name']}\n'
                            'To: ${leaveRequest['rollNumber']}\n',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white, // Light text color for readability
                        ),
                      ),
                      Row(
                        children: [
                          if (leaveRequest['status'] == 'yet to be approved') ...[
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => updateRequestStatus(docId, 'Approved', hostel),
                          ),
                          const SizedBox(width: 5),
                          // Reject button (only show if pending)
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => updateRequestStatus(docId, 'Rejected', hostel),
                          ),
              ]


                        ],
                      )


                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Status display
                      Text(
                        "Status: ${leaveRequest['status']}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: leaveRequest['status'] == 'Approved'
                              ? Colors.greenAccent // Green for approved
                              : leaveRequest['status'] == 'Rejected'
                              ? Colors.redAccent // Red for rejected
                              : Colors.orangeAccent, // Yellow for pending
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Approve button (only show if pending)

                        ],
                      ),
                    ],
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
