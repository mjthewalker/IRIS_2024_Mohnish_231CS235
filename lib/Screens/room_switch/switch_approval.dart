import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data and models/hostel_change_model.dart';

class RoomChangeFinalApproval extends StatefulWidget {
  final Map<String,dynamic> user1;
  final Map<String,dynamic> user2;

  RoomChangeFinalApproval({required this.user1,required this.user2});

  @override
  RoomChangeFinalApprovalState createState() =>
      RoomChangeFinalApprovalState();
}

class RoomChangeFinalApprovalState extends State<RoomChangeFinalApproval> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _approveRequest() async {

    await _firestore.collection('users')
        .doc(widget.user1['uid'])
        .set({
      "hostelInfo": {
        "floor": widget.user2['floor'],
        "hostelName": widget.user2['hostel'],
        "roomNumber": widget.user2['room'],
        "wing": widget.user2['wing']
      }
    }, SetOptions(merge: true));
    await _firestore.collection('users')
        .doc(widget.user2['uid'])
        .set({
      "hostelInfo": {
        "floor": widget.user1['floor'],
        "hostelName": widget.user1['hostel'],
        "roomNumber": widget.user1['room'],
        "wing": widget.user1['wing']
      }
    }, SetOptions(merge: true));

    await _firestore.collection('room_exchange')
        .doc(widget.user1['hostel'])
        .set({
      widget.user1['key']: {
        "${widget.user1['rollNumber']}": {
          "Status": "Approved"
        },
        "${widget.user2['rollNumber']}": {
          "Status": "Approved"
        },
      }

    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Request Approved')));
    Navigator.pop(context, true);
  }

  Future<void> _denyRequest() async {
    await _firestore.collection('room_exchange')
        .doc(widget.user1['hostel'])
        .set({
      widget.user1['key'] : {
        "${widget.user1['rollNumber']}": {
          "Status": "Denied"
        },
        "${widget.user2['rollNumber']}": {
          "Status": "Denied"
        },
      }

    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Request Denied')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.grey[850], // Dark background
      appBar: AppBar(
        title: Text(
          "Approval for ${widget.user1['name']} and ${widget.user1['name']}",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent, // Accent color for title
          ),
        ),
        backgroundColor: Colors.grey[900], // Dark AppBar
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              color: Colors.grey[900], // Dark card background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8, // Shadow for depth
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Details',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent, // Accent color for heading
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailText('Name', widget.user1['name']),
                    _buildDetailText('Roll Number', widget.user1['rollNumber']),
                    _buildDetailText('Name', widget.user2['name']),
                    _buildDetailText('Roll Number', widget.user2['rollNumber']),
                    const SizedBox(height: 16),
                    Text(
                      'Current Room Details',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent, // Accent color for heading
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailText('Hostel', widget.user1['hostel']),
                    _buildDetailText('Floor', widget.user1['floor']),
                    _buildDetailText('Room', widget.user1['room']),
                    _buildDetailText('Wing', widget.user1['wing']),
                    const SizedBox(height: 16),
                    Text(
                      'New Room Details',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent, // Accent color for heading
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailText('New Hostel', widget.user2['hostel']),
                    _buildDetailText('New Floor', widget.user2['floor']),
                    _buildDetailText('New Room', widget.user2['room']),
                    _buildDetailText('New Wing', widget.user2['wing']),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _approveRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // Approve button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Approve',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _denyRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Deny button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Deny',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
