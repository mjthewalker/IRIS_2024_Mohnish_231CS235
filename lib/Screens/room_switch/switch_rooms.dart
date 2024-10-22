import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Data%20and%20models/student_list_model.dart';

class SwitchRooms extends StatefulWidget {
  StudentList studentinfo;
  SwitchRooms({required this.studentinfo});

  @override
  _SwitchRoomsState createState() => _SwitchRoomsState();
}

class _SwitchRoomsState extends State<SwitchRooms> {
  final _formKey = GlobalKey<FormState>();
  String _nameController = '';
  String _room = '';
  String _roll = '';
  String _theirRollNumber = '';
  String _theirRoomNumber = '';



  // Method to handle form submission
  void _submitForm(BuildContext context) async {
    _formKey.currentState!.save();
    String x='';
    if (int.parse(_room)<int.parse(_theirRoomNumber)) x = _room + '<->' + _theirRoomNumber;
    else x= _theirRoomNumber + '<->' + _room;

    await FirebaseFirestore.instance.collection('room_exchange').doc(widget.studentinfo.hostelinfo.hostelName).set({
      x : {
        _roll :{
          "name": widget.studentinfo.name,
          "rollNumber": _roll,
          "hostel": widget.studentinfo.hostelinfo.hostelName,
          "floor": widget.studentinfo.hostelinfo.floor,
          "wing": widget.studentinfo.hostelinfo.wing,
          "room": widget.studentinfo.hostelinfo.roomNumber,
          "their_roll": _theirRollNumber,
          "uid" : widget.studentinfo.uid,
          "key" : x
        },
      }
    },SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Request submitted successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Apply for Room Switch",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent, // Accent color for title
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      backgroundColor: Colors.grey[850], // Dark background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Name field
              Card(
                color: Colors.grey[900], // Dark card background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Your Name",

                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nameController = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Roll number field
              Card(
                color: Colors.grey[900], // Dark card background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Your Roll Number",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your roll number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _roll = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),


              // Leave reason field
              Card(
                color: Colors.grey[900], // Dark card background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: TextFormField(

                  decoration: const InputDecoration(
                    labelText: "Your Room Number",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16),
                  ),

                  style: TextStyle(color: Colors.white),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a proper roll number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _room = value!;
                  },
                ),
              ),
              Card(
                color: Colors.grey[900], // Dark card background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: TextFormField(

                  decoration: const InputDecoration(
                    labelText: "Their Roll Number",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16),
                  ),

                  style: TextStyle(color: Colors.white),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a proper roll number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _theirRollNumber = value!;
                  },
                ),
              ),
              Card(
                color: Colors.grey[900], // Dark card background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: TextFormField(

                  decoration: const InputDecoration(
                    labelText: "Their room number",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16),
                  ),

                  style: TextStyle(color: Colors.white),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a proper roll number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _theirRoomNumber = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () {

                    _submitForm(context);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent, // Match previous theme
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners for button
                  ),
                ),
                child:  Text('Submit',style: TextStyle(color: Colors.grey[900]),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
