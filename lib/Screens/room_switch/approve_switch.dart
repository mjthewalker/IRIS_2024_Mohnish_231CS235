import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Data%20and%20models/loading_screen.dart';
import 'package:iris_rec/Screens/room_switch/switch_approval.dart';

class ApproveSwitch extends StatefulWidget {
  const ApproveSwitch({super.key});

  @override
  _ApproveSwitchState createState() => _ApproveSwitchState();
}

class _ApproveSwitchState extends State<ApproveSwitch> {

  Future<List<Map<String, dynamic>>> getAllRequests() async {
    List<Map<String, dynamic>> allRequests = [];

    try {
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('room_exchange');
      QuerySnapshot requestsSnapshot = await requestsCollection.get();

      for (var requestDoc in requestsSnapshot.docs) {
        Map<String, dynamic> requestData = requestDoc.data() as Map<String, dynamic>;

        // Iterate over user requests in the document
        requestData.forEach((userKey, userData) {


          for (var data in userData.values) {
            String data1 = data['their_roll'];
            if (userData.containsKey(data1)) {
              var data2 = userData[data1];
              if (data2['their_roll'] == data['rollNumber']) {
                bool exists = allRequests.any((request) =>
                    request.containsKey(userKey));
                if (!exists) {
                  allRequests.add({
                    userKey: {
                      'user 1': {
                        'name': data['name'],
                        'rollNumber': data['rollNumber'],
                        'hostel': data['hostel'],
                        'floor': data['floor'],
                        'wing': data['wing'],
                        'room': data['room'],
                        'uid' : data['uid'],
                        'key': data['key'],
                        'Status':data['Status']
                      },
                      'user 2': {
                        'name': data2['name'],
                        'rollNumber': data2['rollNumber'],
                        'hostel': data2['hostel'],
                        'floor': data2['floor'],
                        'wing': data2['wing'],
                        'room': data2['room'],
                        'uid' : data2['uid'],
                        'key' : data2['key'],
                        'Status':data2['Status']
                      }
                    }
                  }

                  );
                }
              }
            }
          }

          /*if (userData != null && userData is Map<String, dynamic>) {
            allRequests.add(userData);
          } else {
            print("userData is null or not a valid map for user: $userKey");
          }
          */
        });


      }
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

      // Provide user feedback
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
          "Room Switch Requests",
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
      body:  FutureBuilder<List<Map<String, dynamic>>>(
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
          print(leaveRequests.length);
          return ListView.builder(
            itemCount: leaveRequests.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> leaveRequest = leaveRequests[index];
              print(leaveRequest);
              Map<String, dynamic> x = {' ' : ' '};
              leaveRequest.forEach((key,value) {
                x = value;
              });

              Map<String,dynamic> user1 = x['user 1'];
              Map<String,dynamic> user2 = x['user 2'];

              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: const BorderSide(color: Colors.tealAccent, width: 1.5),
                ),
                elevation: 8,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomChangeFinalApproval(user1: user1, user2: user2),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      "Room ${user1['room']} <-> ${user2['room']}",
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
                          'Student 1: ${user1['name']}\n'
                              'Student 2: ${user2['name']}\n'
                          'hostel : ${user1['hostel']}'
                              ,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),



                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Status display
                        const SizedBox(height: 13,),
                        Text(
                          "Status: ${user1['Status']}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: user1['Status'] == 'Approved'
                                ? Colors.greenAccent
                                : user1['Status'] == 'Denied'
                                ? Colors.redAccent
                                : Colors.orangeAccent,
                          ),
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
