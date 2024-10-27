import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Data and models/hostel_data.dart';

class HostelInfo extends StatelessWidget {
  final String hostelName;
  final Box hostelBox;

  const HostelInfo({super.key, required this.hostelName, required this.hostelBox});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Hostel Information",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: hostelBox.listenable(),
              builder: (context, Box box, widget) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hostel information available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  Hostel? hostel = box.get(hostelName);

                  if (hostel == null) {
                    return Center(
                      child: Text(
                        'Hostel $hostelName not found!',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: hostel.floors.length,
                    itemBuilder: (context, index) {
                      Floor floor = hostel.floors[index];

                      return Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: ExpansionTile(
                          title: Text(
                            'Floor ${floor.floorNumber}',
                            style: GoogleFonts.poppins(
                              color: Colors.tealAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: floor.wings.map((wing) {
                            return ListTile(
                              title: Text(
                                wing.wingName,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                'Capacity: ${wing.capacity}, Number of Rooms: ${wing.availableRooms}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                bool? confirmDelete = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: Text('Are you sure you want to delete $hostelName? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmDelete == true) {
                  try {
                    await FirebaseFirestore.instance.collection('hostels').doc(hostelName).delete();
                    await FirebaseFirestore.instance.collection('requests').doc(hostelName).delete();
                    await FirebaseFirestore.instance.collection('new_hostels').doc(hostelName).delete();
                    await hostelBox.delete(hostelName);
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error deleting hostel: $e'),
                    ));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Delete Hostel",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
