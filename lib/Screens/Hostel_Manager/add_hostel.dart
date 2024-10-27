import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../Data and models/hostel_data.dart';

class HostelLayoutForm extends StatefulWidget {
  const HostelLayoutForm({super.key});

  @override
  _HostelLayoutFormState createState() => _HostelLayoutFormState();
}

class _HostelLayoutFormState extends State<HostelLayoutForm> {
  final _formKey = GlobalKey<FormState>();
  Box? hostelBox;

  String hostelName = '';
  String wardenId = '';
  String occupancy = '';
  String imgSrc = '';
  int numberOfFloors = 0;

  List<List<Wing>> wingsData = [];

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    if (!Hive.isBoxOpen('hostelbox6')) {
      hostelBox = await Hive.openBox<Hostel>('hostelbox6');
    } else {
      hostelBox = Hive.box<Hostel>('hostelbox6');
    }
  }

  List<Widget> _buildWingInputs(int floorIndex) {
    return [
      _buildWingInput("Right Wing", floorIndex, 0),
      _buildWingInput("Left Wing", floorIndex, 1),
    ];
  }

  Widget _buildWingInput(String wingName, int floorIndex, int wingIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          wingName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Capacity of $wingName', labelStyle: const TextStyle(color: Colors.white),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            int capacity = int.tryParse(value) ?? 0;
            wingsData[floorIndex][wingIndex] =
                Wing(wingName: wingName, capacity: capacity, availableRooms: wingsData[floorIndex][wingIndex].availableRooms);
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Available Rooms in $wingName', labelStyle: const TextStyle(color: Colors.white),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            int availableRooms = int.tryParse(value) ?? 0;
            wingsData[floorIndex][wingIndex] =
                Wing(wingName: wingName, capacity: wingsData[floorIndex][wingIndex].capacity, availableRooms: availableRooms);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFloorInput(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Floor ${index + 1}', style: const TextStyle(fontSize: 18, color: Colors.white)),
        ..._buildWingInputs(index),
      ],
    );
  }

  Future<void> _saveHostelData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<Floor> floors = [];
      for (int i = 0; i < numberOfFloors; i++) {
        floors.add(Floor(floorNumber: i, wings: wingsData[i]));
      }

      Hostel hostel = Hostel(
        hostelName: hostelName,
        floors: floors,
        wardenId: wardenId,
        imgSrc: imgSrc,
        occupancy: occupancy,
      );

      await hostelBox!.put(hostelName, hostel);
      try {
        await FirebaseFirestore.instance.collection('hostels').doc('$hostelName').set({
          'Floor 0': {}
        });
        await FirebaseFirestore.instance.collection('requests').doc('$hostelName').set({
          'Sample': {}
        });
      } catch (e) {
        print("error");
      }

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hostel data saved successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text(
          "Add New Hostel",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hostel Name', labelStyle: TextStyle(color: Colors.white)),
                onChanged: (value) {
                  hostelName = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Warden ID', labelStyle: TextStyle(color: Colors.white)),
                onChanged: (value) {
                  wardenId = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hostel Image Address', labelStyle: TextStyle(color: Colors.white)),
                onChanged: (value) {
                  imgSrc = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Occupancy', labelStyle: TextStyle(color: Colors.white)),
                onChanged: (value) {
                  occupancy = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Number of Floors', labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    numberOfFloors = int.tryParse(value) ?? 0;
                    wingsData = List.generate(numberOfFloors, (index) => [
                      Wing(wingName: 'Right Wing', capacity: 0, availableRooms: 0),
                      Wing(wingName: 'Left Wing', capacity: 0, availableRooms: 0),
                    ]);
                  });
                },
              ),
              ...List.generate(numberOfFloors, (index) => _buildFloorInput(index)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveHostelData,
                child: const Text('Save Hostel Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
