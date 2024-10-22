import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:iris_rec/Data%20and%20models/student_list_model.dart';
import '../../Data and models/common_card.dart';
import '../../Data and models/hostel_data.dart'; // Import your Hive models
import 'hostelscreen.dart'; // Import the detail screen

class HostelRegistrationScreen extends StatefulWidget {
  final String mode;
  final Map<String, dynamic>? currentDetails;
  final StudentList studentdetail;
  final String? name;
  final String? rollNumber;

  HostelRegistrationScreen({
    required this.mode,
    this.currentDetails,
    this.name,
    this.rollNumber,
    required this.studentdetail,
  });

  @override
  State<HostelRegistrationScreen> createState() => _HostelRegistrationScreenState();
}

class _HostelRegistrationScreenState extends State<HostelRegistrationScreen> {
  late Box<Hostel> hostelBox;
  late Future<List<Hostel>> allHostels;

  @override
  void initState() {
    super.initState();
    hostelBox = Hive.box<Hostel>('hostelBox6');
    allHostels = getAllHostels();
  }

  Future<List<Hostel>> getAllHostels() async {
    List<Hostel> hostels = await HostelDataBase(hostelBox).getAllHostels();
    if (widget.mode == "change" && widget.currentDetails?['hostelName'] != null) {
      hostels = hostels.where((hostel) => hostel.hostelName != widget.currentDetails!['hostelName']).toList();
    }
    return hostels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent, // Accent color for title
          ),
        ),
        backgroundColor: Colors.grey[900], // Dark background for AppBar
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.tealAccent), // Accent color for icons
        elevation: 2, // Slight elevation for the AppBar
      ),
      backgroundColor: Colors.grey[850], // Dark background for the main body
      body: FutureBuilder<List<Hostel>>(
        future: allHostels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          }

          List<Hostel> hostels = snapshot.data ?? [];
          if (hostels.isEmpty) {
            return const Center(child: Text('No hostels available.'));
          }

          return ListView.builder(
            itemCount: hostels.length,
            itemBuilder: (context, index) {
              final hostel = hostels[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HostelDetailScreen(
                          hostel: hostel,
                          mode: widget.mode,
                          currentDetails: widget.currentDetails,
                          name: widget.name,
                          roll: widget.rollNumber,
                          studentdetail: widget.studentdetail,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      // First card: Image only
                      CommonCard(
                        color: Colors.grey[900],
                        radius: 15,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                          child: AspectRatio(
                            aspectRatio: 2.7,
                            child: Image.asset(
                              hostel.imgSrc,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Second card: Text information (hostel name and warden ID)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          //side: BorderSide(color: Colors.tealAccent, width: 1.2),
                        ),
                        elevation: 10, // Subtle shadow for the card
                        color: Colors.grey[800], // Softer dark color for the card
                        shadowColor: Colors.black38, // Shadow color
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                hostel.hostelName,
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                 hostel.occupancy.toLowerCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.tealAccent, // Accent color for warden ID
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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

  String _getAppBarTitle() {
    switch (widget.mode) {
      case "register":
        return "Hostel Registration";
      case "realloc":
        return "Reallocate User";
      default:
        return "Apply for Hostel Change";
    }
  }
}
