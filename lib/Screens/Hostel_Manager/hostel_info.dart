import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Data and models/hostel_data.dart';
 // Assuming this is where your Hive models are defined

class HostelInfo extends StatelessWidget {
  final String hostelName;
  final Box hostelBox;
  const HostelInfo({required this.hostelName,required this.hostelBox});


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Information'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: hostelBox.listenable(),
              builder: (context, Box box, widget) {
                if (box.isEmpty) {
                  return Center(
                    child: Text('No hostel information available'),
                  );
                } else {
                  // Retrieve the hostel data from the box using the hostel name
                  Hostel? hostel = box.get(hostelName); // Add null check

                  if (hostel == null) {
                    return Center(
                      child: Text('Hostel $hostelName not found!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: hostel.floors.length,
                    itemBuilder: (context, index) {
                      Floor floor = hostel.floors[index];

                      return ExpansionTile(
                        title: Text('Floor ${floor.floorNumber}'),
                        children: floor.wings.map((wing) {
                          return ListTile(
                            title: Text('${wing.wingName} Wing'),
                            subtitle: Text(
                                'Capacity: ${wing.capacity}, Available Rooms: ${wing.availableRooms}'),
                          );
                        }).toList(),
                      );
                    },
                  );
                }
              },
            ),
          ),
          TextButton(onPressed: () async{
            await FirebaseFirestore.instance.collection('hostels').doc('$hostelName').delete();
            await FirebaseFirestore.instance.collection('requests').doc('$hostelName').delete();
            await hostelBox.delete(hostelName);
            Navigator.pop(context,true);
          }, child: Text("Delete Hostel"))
        ],
      ),
    );
  }
}
