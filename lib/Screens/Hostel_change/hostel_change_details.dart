import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Data and models/hostel_change_model.dart';

class HostelChangeFinalApproval extends StatefulWidget {
  final HostelChangeRequest finalData;

  HostelChangeFinalApproval({required this.finalData});

  @override
  HostelChangeFinalApprovalState createState() =>
      HostelChangeFinalApprovalState();
}

class HostelChangeFinalApprovalState extends State<HostelChangeFinalApproval> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Approve function
  Future<void> _approveRequest() async {

    await _firestore.collection('hostels')
          .doc(widget.finalData.hostelChangeDetails.currentDetails.currentHostel)
          .set({
          "Floor ${widget.finalData.hostelChangeDetails.currentDetails.currentFloor}" : {
            "${widget.finalData.hostelChangeDetails.currentDetails.currentWing}" : {
              "Room ${widget.finalData.hostelChangeDetails.currentDetails.currentRoom}" : FieldValue.increment(-1)
            }
          }
    },SetOptions(merge: true));
    await _firestore.collection('hostels')
        .doc(widget.finalData.hostelChangeDetails.newRoomDetails.newHostel)
        .set({
      "Floor ${widget.finalData.hostelChangeDetails.newRoomDetails.newFloor}" : {
        "${widget.finalData.hostelChangeDetails.newRoomDetails.newWing}" : {
          "Room ${widget.finalData.hostelChangeDetails.newRoomDetails.newRoom}" : FieldValue.increment(1)
        }
      }
    },SetOptions(merge: true));
    await _firestore.collection('users')
        .doc(widget.finalData.personalDetails.uid)
        .set({
      "hostelInfo" : {
        "floor" : widget.finalData.hostelChangeDetails.newRoomDetails.newFloor,
        "hostelName" : widget.finalData.hostelChangeDetails.newRoomDetails.newHostel,
        "roomNumber" : widget.finalData.hostelChangeDetails.newRoomDetails.newRoom,
        "wing" : widget.finalData.hostelChangeDetails.newRoomDetails.newWing
      }
    },SetOptions(merge: true));
    await _firestore
        .collection('requests')
        .doc(widget.finalData.hostelChangeDetails.newRoomDetails.newHostel) // Assuming roll number as ID
        .set({
      "${widget.finalData.personalDetails.email}" : {
        "Status" : "Approved"
      }
    },SetOptions(merge: true));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Request Approved')));
    Navigator.pop(context,true);
    return;
  }

  // Deny function
  Future<void> _denyRequest() async {
    await _firestore
        .collection('requests')
        .doc(widget.finalData.hostelChangeDetails.newRoomDetails.newHostel) // Assuming roll number as ID
        .set({
          "${widget.finalData.personalDetails.email}" : {
            "Status" : "Denied"
          }
    },SetOptions(merge: true));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Request Denied')));
    Navigator.pop(context,true);
    return;
  }

  @override
  Widget build(BuildContext context) {
    final personalDetails = widget.finalData.personalDetails;
    final currentDetails = widget.finalData.hostelChangeDetails.currentDetails;
    final newRoomDetails = widget.finalData.hostelChangeDetails.newRoomDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text("Approval for ${personalDetails.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Details', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Name: ${personalDetails.name}', style: const TextStyle(fontSize: 18)),
            Text('Roll Number: ${personalDetails.roll}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Current Room Details', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Hostel: ${currentDetails.currentHostel}', style: const TextStyle(fontSize: 18)),
            Text('Floor: ${currentDetails.currentFloor}', style: const TextStyle(fontSize: 18)),
            Text('Room: ${currentDetails.currentRoom}', style: const TextStyle(fontSize: 18)),
            Text('Wing: ${currentDetails.currentWing}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('New Room Details', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('New Hostel: ${newRoomDetails.newHostel}', style: const TextStyle(fontSize: 18)),
            Text('New Floor: ${newRoomDetails.newFloor}', style: const TextStyle(fontSize: 18)),
            Text('New Room: ${newRoomDetails.newRoom}', style: const TextStyle(fontSize: 18)),
            Text('New Wing: ${newRoomDetails.newWing}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _approveRequest,
                  child: const Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: _denyRequest,
                  child: const Text('Deny'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}