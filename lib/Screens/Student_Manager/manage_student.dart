import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iris_rec/Screens/Hostel_registration/hostelreg.dart';

import '../../Data and models/student_list_model.dart';

class ManageStudent extends StatelessWidget{
  final StudentList studentdata;
  ManageStudent({required this.studentdata});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(studentdata.name),
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const Text('Personal Details', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text('Name: ${studentdata.name}', style: const TextStyle(fontSize: 18)),
          Text('Roll Number: ${studentdata.rollnumber}', style: const TextStyle(fontSize: 18)),
          Text('email: ${studentdata.email}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          const Text('Current Room Details', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text('Hostel: ${studentdata.hostelinfo.hostelName}', style: const TextStyle(fontSize: 18)),
          Text('Floor: ${studentdata.hostelinfo.floor}', style: const TextStyle(fontSize: 18)),
          Text('Room: ${studentdata.hostelinfo.roomNumber}', style: const TextStyle(fontSize: 18)),
          Text('Wing: ${studentdata.hostelinfo.wing}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          const Text('New Room Details', style: TextStyle(fontSize: 20)),
          TextButton(onPressed: () async{
            if (studentdata.hostelinfo.hostelName == "No hostel alloted"){
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Deallocation failed, student already deallocated')));
              return;
            }
            await FirebaseFirestore.instance.collection('users').doc(studentdata.uid).set({
              'hostelInfo' : {
                'floor' : "No Floor alloted",
                'hostelName' : "No hostel alloted",
                "roomNumber" : "No room alloted",
                "wing" : "No wing alloted",
              }
            },SetOptions(merge: true));
            await FirebaseFirestore.instance.collection('hostels').doc(studentdata.hostelinfo.hostelName).set({
              'Floor ${studentdata.hostelinfo.floor}' : {
                '${studentdata.hostelinfo.wing}' : {
                  'Room ${studentdata.hostelinfo.roomNumber}' : FieldValue.increment(-1)
                }
              }
            },SetOptions(merge: true));
            Navigator.pop(context,true);
          }, child:Text("Deallocate Room")),
          TextButton(onPressed: () async{
          if (studentdata.hostelinfo.hostelName != "No hostel alloted"){
            await FirebaseFirestore.instance.collection('hostels').doc(studentdata.hostelinfo.hostelName).set({
              'Floor ${studentdata.hostelinfo.floor}' : {
                '${studentdata.hostelinfo.wing}' : {
                  'Room ${studentdata.hostelinfo.roomNumber}' : FieldValue.increment(-1)
                }
              }
            },SetOptions(merge: true));
            }

            await FirebaseFirestore.instance.collection('users').doc(studentdata.uid).set({
              'hostelInfo' : {
                'floor' : "No Floor alloted",
                'hostelName' : "No hostel alloted",
                "roomNumber" : "No room alloted",
                "wing" : "No wing alloted",
              }
            },SetOptions(merge: true));


            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HostelRegistrationScreen(mode: "realloc",studentdetail: studentdata,)),
            );
          }, child: Text("Reallocate Room"),)
        ],
      ),
    );
  }
}