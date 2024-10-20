import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../Data and models/hostel_data.dart';

class HostelLayoutForm extends StatefulWidget {
  @override
  _HostelLayoutFormState createState() => _HostelLayoutFormState();
}

class _HostelLayoutFormState extends State<HostelLayoutForm> {
  final _formKey = GlobalKey<FormState>();
  Box? hostelBox;

  // Form state variables
  String hostelName = '';
  String wardenId = '';
  String imgSrc = '';
  int numberOfFloors = 0;

  // A list that holds a list of wings per floor (fixed to 2 wings)
  List<List<Wing>> wingsData = [];

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    if (!Hive.isBoxOpen('hostelbox5')) {
      hostelBox = await Hive.openBox<Hostel>('hostelbox5');
    } else {
      hostelBox = Hive.box<Hostel>('hostelbox5');
    }
  }

  // Method to create fixed wing inputs
  List<Widget> _buildWingInputs(int floorIndex) {
    return [
      _buildWingInput("Right Wing", floorIndex, 0),
      _buildWingInput("Left Wing", floorIndex, 1),
    ];
  }

  // Build input for a specific wing
  Widget _buildWingInput(String wingName, int floorIndex, int wingIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display wing name as static text
        Text(
          wingName,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        // Capacity input for the wing
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Capacity of $wingName',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            int capacity = int.tryParse(value) ?? 0; // Fallback to 0 on parse failure
            wingsData[floorIndex][wingIndex] =
                Wing(wingName: wingName, capacity: capacity, availableRooms: wingsData[floorIndex][wingIndex].availableRooms);
          },
        ),
        // Available rooms input for the wing
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Available Rooms in $wingName',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            int availableRooms = int.tryParse(value) ?? 0; // Fallback to 0 on parse failure
            wingsData[floorIndex][wingIndex] =
                Wing(wingName: wingName, capacity: wingsData[floorIndex][wingIndex].capacity, availableRooms: availableRooms);
          },
        ),
        SizedBox(height: 16), // Add space between wings
      ],
    );
  }

  // Build form for a floor
  Widget _buildFloorInput(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Floor ${index + 1}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ..._buildWingInputs(index),
      ],
    );
  }

  // Form submission logic
  Future<void> _saveHostelData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a list of Floor objects
      List<Floor> floors = [];
      for (int i = 0; i < numberOfFloors; i++) {
        floors.add(Floor(floorNumber: i , wings: wingsData[i]));
      }

      // Create Hostel object
      Hostel hostel = Hostel(
        hostelName: hostelName,
        floors: floors,
        wardenId: wardenId,
        imgSrc: imgSrc,
      );

      // Save hostel object to Hive
      await hostelBox!.put(hostelName, hostel);
      try{
        await FirebaseFirestore.instance.collection('hostels').doc('${hostelName}').set({
          'Floor 0' :{}
        });
        await FirebaseFirestore.instance.collection('requests').doc('${hostelName}').set({
          'Sample' :{}
        });
      } catch(e){
        print("error");
      }

      Navigator.pop(context,true);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hostel data saved successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hostel Layout Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Hostel Name'),
                onChanged: (value) {
                  hostelName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Warden ID'),
                onChanged: (value) {
                  wardenId = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Hostel Image Address'),
                onChanged: (value) {
                  imgSrc = value;
                },
              ),
              // Set the number of floors directly, assuming it's handled elsewhere
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Floors'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    numberOfFloors = int.tryParse(value) ?? 0; // Use tryParse for safety
                    wingsData = List.generate(numberOfFloors, (index) => [
                      Wing(wingName: 'Right Wing', capacity: 0, availableRooms: 0),
                      Wing(wingName: 'Left Wing', capacity: 0, availableRooms: 0)
                    ]);
                  });
                },
              ),
              ...List.generate(numberOfFloors, (index) => _buildFloorInput(index)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveHostelData,
                child: Text('Save Hostel Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}