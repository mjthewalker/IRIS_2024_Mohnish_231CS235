import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Screens/Hostel_registration/hostelreg.dart';

import '../../Data and models/student_list_model.dart';

class ManageStudent extends StatelessWidget {
  final StudentList studentdata;

  ManageStudent({required this.studentdata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          studentdata.name,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent, // Accent color for title
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      backgroundColor: Colors.grey[850], // Dark background for the body
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
                    _buildDetailText('Name', studentdata.name),
                    _buildDetailText('Roll Number', studentdata.rollnumber),
                    _buildDetailText('Email', studentdata.email),
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
                    _buildDetailText('Hostel', studentdata.hostelinfo.hostelName),
                    _buildDetailText('Floor', studentdata.hostelinfo.floor),
                    _buildDetailText('Room', studentdata.hostelinfo.roomNumber),
                    _buildDetailText('Wing', studentdata.hostelinfo.wing),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Deallocate Room Button
            ElevatedButton(
              onPressed: () async {
                if (studentdata.hostelinfo.hostelName == "No hostel allotted") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deallocation failed, student already deallocated')),
                  );
                  return;
                }
                await FirebaseFirestore.instance.collection('users').doc(studentdata.uid).set({
                  'hostelInfo': {
                    'floor': "No Floor allotted",
                    'hostelName': "No hostel allotted",
                    'roomNumber': "No room allotted",
                    'wing': "No wing allotted",
                  }
                }, SetOptions(merge: true));

                await FirebaseFirestore.instance.collection('hostels').doc(studentdata.hostelinfo.hostelName).set({
                  'Floor ${studentdata.hostelinfo.floor}': {
                    '${studentdata.hostelinfo.wing}': {
                      'Room ${studentdata.hostelinfo.roomNumber}': FieldValue.increment(-1)
                    }
                  }
                }, SetOptions(merge: true));

                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Deallocate button color
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Deallocate Room',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Reallocate Room Button
            ElevatedButton(
              onPressed: () async {
                if (studentdata.hostelinfo.hostelName != "No hostel allotted") {
                  await FirebaseFirestore.instance.collection('hostels').doc(studentdata.hostelinfo.hostelName).set({
                    'Floor ${studentdata.hostelinfo.floor}': {
                      '${studentdata.hostelinfo.wing}': {
                        'Room ${studentdata.hostelinfo.roomNumber}': FieldValue.increment(-1)
                      }
                    }
                  }, SetOptions(merge: true));
                }

                await FirebaseFirestore.instance.collection('users').doc(studentdata.uid).set({
                  'hostelInfo': {
                    'floor': "No Floor allotted",
                    'hostelName': "No hostel allotted",
                    'roomNumber': "No room allotted",
                    'wing': "No wing allotted",
                  }
                }, SetOptions(merge: true));

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HostelRegistrationScreen(mode: "realloc", studentdetail: studentdata)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Reallocate button color
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Reallocate Room',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
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
                color: Colors.tealAccent, // Accent color for label
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white70, // Light text color for value
              ),
            ),
          ],
        ),
      ),
    );
  }
}
