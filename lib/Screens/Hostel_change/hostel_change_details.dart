import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data and models/hostel_change_model.dart';
import '../Hostel_Dashboard/bloc/iris_bloc.dart';

class HostelChangeFinalApproval extends StatefulWidget {
  final HostelChangeRequest finalData;

  const HostelChangeFinalApproval({super.key, required this.finalData});

  @override
  HostelChangeFinalApprovalState createState() =>
      HostelChangeFinalApprovalState();
}

class HostelChangeFinalApprovalState extends State<HostelChangeFinalApproval> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _approveRequest() async {
    await _firestore.collection('hostels')
        .doc(widget.finalData.hostelChangeDetails.currentDetails.currentHostel)
        .set({
      "Floor ${widget.finalData.hostelChangeDetails.currentDetails.currentFloor}": {
        widget.finalData.hostelChangeDetails.currentDetails.currentWing: {
          "Room ${widget.finalData.hostelChangeDetails.currentDetails.currentRoom}": FieldValue.increment(-1)
        }
      }
    }, SetOptions(merge: true));
    await _firestore.collection('hostels')
        .doc(widget.finalData.hostelChangeDetails.newRoomDetails.newHostel)
        .set({
      "Floor ${widget.finalData.hostelChangeDetails.newRoomDetails.newFloor}": {
        widget.finalData.hostelChangeDetails.newRoomDetails.newWing: {
          "Room ${widget.finalData.hostelChangeDetails.newRoomDetails.newRoom}": FieldValue.increment(1)
        }
      }
    }, SetOptions(merge: true));
    await _firestore.collection('users')
        .doc(widget.finalData.personalDetails.uid)
        .set({
      "hostelInfo": {
        "floor": widget.finalData.hostelChangeDetails.newRoomDetails.newFloor,
        "hostelName": widget.finalData.hostelChangeDetails.newRoomDetails.newHostel,
        "roomNumber": widget.finalData.hostelChangeDetails.newRoomDetails.newRoom,
        "wing": widget.finalData.hostelChangeDetails.newRoomDetails.newWing
      }
    }, SetOptions(merge: true));
    await _firestore.collection('requests')
        .doc(widget.finalData.hostelChangeDetails.newRoomDetails.newHostel)
        .set({
      widget.finalData.personalDetails.email: {
        "Status": "Approved"
      }
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Request Approved')));
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadData());
    Navigator.pop(context, true);
  }

  Future<void> _denyRequest() async {
    await _firestore.collection('requests')
        .doc(widget.finalData.hostelChangeDetails.newRoomDetails.newHostel)
        .set({
      widget.finalData.personalDetails.email: {
        "Status": "Denied"
      }
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Request Denied')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final personalDetails = widget.finalData.personalDetails;
    final currentDetails = widget.finalData.hostelChangeDetails.currentDetails;
    final newRoomDetails = widget.finalData.hostelChangeDetails.newRoomDetails;

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text(
          "Approval for ${personalDetails.name}",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
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
                        color: Colors.tealAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailText('Name', personalDetails.name),
                    _buildDetailText('Roll Number', personalDetails.roll),
                    const SizedBox(height: 16),
                    Text(
                      'Current Room Details',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailText('Hostel', currentDetails.currentHostel),
                    _buildDetailText('Floor', currentDetails.currentFloor),
                    _buildDetailText('Room', currentDetails.currentRoom),
                    _buildDetailText('Wing', currentDetails.currentWing),
                    const SizedBox(height: 16),
                    Text(
                      'New Room Details',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailText('New Hostel', newRoomDetails.newHostel),
                    _buildDetailText('New Floor', newRoomDetails.newFloor),
                    _buildDetailText('New Room', newRoomDetails.newRoom),
                    _buildDetailText('New Wing', newRoomDetails.newWing),
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
                    backgroundColor: Colors.greenAccent,
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
                    backgroundColor: Colors.redAccent,
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
