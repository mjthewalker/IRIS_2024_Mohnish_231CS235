import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iris_rec/Data%20and%20models/student_list_model.dart';
import '../../Data and models/common_card.dart';
import '../../Data and models/hostel_data.dart'; // Import your Hive models
import 'hostelscreen.dart';
import 'hostelscreen.dart'; // Import the detail screen

class HostelRegistrationScreen extends StatefulWidget {
  final String mode;
  final Map<String,dynamic>? currentDetails;
  final StudentList studentdetail;
  final String? name;
  final String? rollNumber;
  HostelRegistrationScreen({required this.mode, this.currentDetails,this.name,this.rollNumber,required this.studentdetail});
  @override
  State<HostelRegistrationScreen> createState() => _HostelRegistrationScreenState();
}

class _HostelRegistrationScreenState extends State<HostelRegistrationScreen> {
  late Box<Hostel> hostelBox; // Define your hostel box
  late Future<List<Hostel>> allHostels;

  // Future to hold the list of hostels

  @override
  void initState() {
    super.initState();
    hostelBox = Hive.box<Hostel>('hostelBox5'); // Initialize your Hive box
    allHostels = getAllHostels(); // Call the function to get hostels
  }

  Future<List<Hostel>> getAllHostels() async {
    List<Hostel> hostels = await HostelDataBase(hostelBox).getAllHostels();
    if (widget.mode == "change" && widget.currentDetails!['hostelName'] != null) {
      hostels = hostels.where((hostel) => hostel.hostelName != widget.currentDetails!['hostelName']).toList();
    }
    return hostels;
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child:  widget.mode == "register" ? Text(
            "Register for a hostel",
            style: TextStyle(color: Colors.black), // Text color for visibility
          ) : widget.mode == "realloc"? const Text("Reallocate user to") : const Text("Apply for hostel change")
        ),
        backgroundColor: Colors.grey[350],
      ),
      backgroundColor: Colors.grey[350],
      body: FutureBuilder<List<Hostel>>(
        future: allHostels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Hostel> hostels = snapshot.data!;
          if (hostels.isEmpty) {
            return const Center(child: Text('No hostels available.'));
          }

          return ListView.builder(
            itemCount: hostels.length,
            itemBuilder: (context, index) {
              final hostel = hostels[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector( // Wrap with GestureDetector
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HostelDetailScreen(hostel: hostel,mode : widget.mode,currentDetails : widget.currentDetails,name: widget.name,roll: widget.rollNumber,studentdetail: widget.studentdetail,), // Pass the hostel object
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      CommonCard(
                        color: Colors.white70,
                        radius: 16,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                          child: AspectRatio(
                            aspectRatio: 2.7,
                            child: Image.asset(
                              hostel.imgSrc, // Use the image source from the hostel data
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0), // Space between image and description
                      Text(
                        hostel.hostelName, // Display the hostel name
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), // Bold for emphasis
                      ),
                      const SizedBox(height: 4.0), // Additional spacing
                      Text(
                        'Warden ID: ${hostel.wardenId}', // Display warden ID
                        style: TextStyle(color: Colors.grey[600]), // Lighter color for less emphasis
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
