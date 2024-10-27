import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Data and models/loading_screen.dart';
import 'hostel_change_details.dart';
import '../../Data and models/hostel_change_model.dart';

class HostelChangeApproval extends StatefulWidget {
  const HostelChangeApproval({super.key});

  @override
  HostelChangeApprovalState createState() => HostelChangeApprovalState();
}

class HostelChangeApprovalState extends State<HostelChangeApproval> {
  late Future<List<HostelChangeRequest>> allChangeRequests;

  @override
  void initState() {
    super.initState();
    allChangeRequests = getAllRequests();
  }

  Future<List<HostelChangeRequest>> getAllRequests() async {
    List<HostelChangeRequest> allRequests = [];

    try {
      CollectionReference hostelsCollection = FirebaseFirestore.instance.collection('requests');
      QuerySnapshot hostelsSnapshot = await hostelsCollection.get();

      for (var hostelDoc in hostelsSnapshot.docs) {
        Map<String, dynamic> hostelData = hostelDoc.data() as Map<String, dynamic>;

        hostelData.forEach((userKey, userData) {
          if (userData is Map<String, dynamic>) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hostel Change Requests",
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
      body: FutureBuilder<List<HostelChangeRequest>>(
        future: allChangeRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearLoadingScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Requests Found'));
          }

          List<HostelChangeRequest> requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              HostelChangeRequest request = requests[index];

              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8,
                shadowColor: Colors.black38,
                child: GestureDetector(
                  onTap: () {
                    if (request.status == "Pending") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            HostelChangeFinalApproval(finalData: request)),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            allChangeRequests = getAllRequests();
                          });
                        }
                      });
                    }
                  },
                  child: ListTile(
                    title: Text(
                      request.personalDetails.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${request.hostelChangeDetails.currentDetails.currentHostel}  ',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              const TextSpan(
                                text: '->  ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: request.hostelChangeDetails.newRoomDetails.newHostel,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.tealAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "Status: ${request.status}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: request.status == 'Approved'
                            ? Colors.greenAccent
                            : request.status == 'Denied'
                            ? Colors.redAccent
                            : Colors.orangeAccent,
                      ),
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
