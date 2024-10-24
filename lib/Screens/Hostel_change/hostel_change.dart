import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hostel_change_details.dart';
import '../../Data and models/hostel_change_model.dart';

class HostelChangeApproval extends StatefulWidget {
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
            color: Colors.tealAccent, // Accent color for AppBar title
          ),
        ),
        backgroundColor: Colors.grey[900], // Dark background for AppBar
        iconTheme: const IconThemeData(color: Colors.tealAccent), // Accent for AppBar icons
        centerTitle: true,
        elevation: 2, // Subtle shadow for AppBar
      ),
      backgroundColor: Colors.grey[850], // Light background for body
      body: FutureBuilder<List<HostelChangeRequest>>(
        future: allChangeRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: GFLoader(type: GFLoaderType.ios)); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error handling
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Requests Found')); // No data found
          }

          List<HostelChangeRequest> requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              HostelChangeRequest request = requests[index];

              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.grey[900], // Dark card background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners for cards
                 // side: BorderSide(color: Colors.tealAccent, width: 1.5), // Accent color border
                ),
                elevation: 8, // Card elevation for shadow effect
                shadowColor: Colors.black38, // Subtle shadow color
                child: GestureDetector(
                  onTap: () {
                    if (request.status=="Pending") {
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
                      '${request.personalDetails.name}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent, // Accent color for title
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
                                  color: Colors.orangeAccent, // Light text color for readability
                                ),
                              ),
                              const TextSpan(
                                text: '->  ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white, // Keeping the arrow color white
                                ),
                              ),
                              TextSpan(
                                text: '${request.hostelChangeDetails.newRoomDetails.newHostel}',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.tealAccent, // Different color for the new hostel
                                ),
                              ),
                            ],
                          ),
                        )

                        /*Text(
                          'New Hostel: ${request.hostelChangeDetails.newRoomDetails.newHostel}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white, // Light text color for readability
                          ),
                        ),*/
                      ],
                    ),
                    trailing: Text(
                      "Status: ${request.status}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: request.status == 'Approved'
                            ? Colors.greenAccent // Green for approved
                            : request.status == 'Denied'
                            ? Colors.redAccent // Red for rejected
                            : Colors.orangeAccent, // Yellow for pending
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