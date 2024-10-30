import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Data and models/loading_screen.dart';

class ManageLeaves extends StatefulWidget {
  const ManageLeaves({super.key});

  @override
  ManageLeaveState createState() => ManageLeaveState();
}

class ManageLeaveState extends State<ManageLeaves> {

  Future<List<Map<String, dynamic>>> getAllRequests() async {
    List<Map<String, dynamic>> allRequests = [];

    try {
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('leaves');
      QuerySnapshot requestsSnapshot = await requestsCollection.get();

      for (var requestDoc in requestsSnapshot.docs) {
        Map<String, dynamic> requestData = requestDoc.data() as Map<String, dynamic>;


        requestData.forEach((userKey, userData) {
          if (userData != null && userData is Map<String, dynamic>) {
            allRequests.add(userData);
          } else {
            print("userData is null or not a valid map for user: $userKey");
          }
        });
      }
      allRequests.sort((a, b) {
        if (a['status'] == 'yet to be approved' && b['status'] != 'yet to be approved') return -1;
        if (a['status'] != 'yet to be approved' && b['status'] == 'yet to be approved') return 1;
        return 0;
      });

    } catch (e) {
      print("Error fetching requests: $e");
    }

    return allRequests;
  }

  Future<void> updateRequestStatus(String docId, String status, String hostel) async {
    try {
      await FirebaseFirestore.instance.collection('leaves').doc(hostel).set({
        docId: {
          "status": status,
        }
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $status')),
      );

      setState(() {});
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
            color: Colors.tealAccent,
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: Colors.grey[850],
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllRequests(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearLoadingScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Leave Requests Found'));
          }

          List<Map<String, dynamic>> leaveRequests = snapshot.data!;

          return ListView.builder(
            itemCount: leaveRequests.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> leaveRequest = leaveRequests[index];
              String docId = leaveRequest['rollNumber'];
              String hostel = leaveRequest['hostel'];

              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: const BorderSide(color: Colors.tealAccent, width: 1.5),
                ),
                elevation: 8,
                child: ListTile(
                  title: Text(
                    "Leave Request",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason: ${leaveRequest['Reason'].length > 30 ? leaveRequest['Reason'].substring(0, 50) + '...' : leaveRequest['Reason']}\n'
                            'From: ${DateFormat('dd-MM-yyyy').format((leaveRequest['FromDate'] as Timestamp).toDate())}\n'
                            'To: ${DateFormat('dd-MM-yyyy').format((leaveRequest['ToDate'] as Timestamp).toDate())}'
                        ,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
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

                      Text(
                        "Status: ${leaveRequest['status']}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: leaveRequest['status'] == 'Approved'
                              ? Colors.greenAccent
                              : leaveRequest['status'] == 'Rejected'
                              ? Colors.redAccent
                              : Colors.orangeAccent,
                        ),
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [


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
