import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Data and models/student_list_model.dart';

class ManageStudent extends StatefulWidget{
  final StudentList studentdata;
  ManageStudent({required this.studentdata});

  @override
  State<ManageStudent> createState() => _ManageStudentState();
}

class _ManageStudentState extends State<ManageStudent> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentdata.name),
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const Text('Personal Details', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text('Name: ${widget.studentdata.name}', style: const TextStyle(fontSize: 18)),
          Text('Roll Number: ${widget.studentdata.rollnumber}', style: const TextStyle(fontSize: 18)),
          Text('email: ${widget.studentdata.email}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          const Text('Current Room Details', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text('Hostel: ${widget.studentdata.hostelinfo.hostelName}', style: const TextStyle(fontSize: 18)),
          Text('Floor: ${widget.studentdata.hostelinfo.floor}', style: const TextStyle(fontSize: 18)),
          Text('Room: ${widget.studentdata.hostelinfo.roomNumber}', style: const TextStyle(fontSize: 18)),
          Text('Wing: ${widget.studentdata.hostelinfo.wing}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          const Text('New Room Details', style: TextStyle(fontSize: 20)),
          TextButton(onPressed: () async{
            await FirebaseFirestore.instance.collection('users').doc(widget.studentdata.uid).set({
              'hostelInfo' : {
                'floor' : "No Floor alloted",
                'hostelName' : "No hostel alloted",
                "roomNumber" : "No room alloted",
                "wing" : "No wing alloted",
              }
            },SetOptions(merge: true));
            await FirebaseFirestore.instance.collection('hostels').doc(widget.studentdata.hostelinfo.hostelName).set({
              'Floor ${widget.studentdata.hostelinfo.floor}' : {
                '${widget.studentdata.hostelinfo.wing}' : {
                  'Room ${widget.studentdata.hostelinfo.roomNumber}' : FieldValue.increment(-1)
                }
              }
            },SetOptions(merge: true));
            Navigator.pop(context,true);
          }, child:Text("Deallocate Room")),
          TextButton(onPressed: ()async{

          }, child: Text("Reallocate Room"),)
        ],
      ),
    );
  }
}