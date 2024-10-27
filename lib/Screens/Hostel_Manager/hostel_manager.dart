import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:iris_rec/Screens/Hostel_Manager/add_hostel.dart';
import 'package:iris_rec/Screens/Hostel_Manager/hostel_info.dart';
import '../../Data and models/common_card.dart';
import '../../Data and models/hostel_data.dart';

class HostelManager extends StatefulWidget {
  const HostelManager({super.key});

  @override
  HostelManagerState createState() => HostelManagerState();
}

class HostelManagerState extends State<HostelManager> {
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
    return hostels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Hostel Manager",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      backgroundColor: Colors.grey[850],
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HostelLayoutForm(),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          allHostels = getAllHostels();
                        });
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Add New Hostel",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
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
                              builder: (context) => HostelInfo(hostelName: hostel.hostelName, hostelBox: hostelBox),
                            ),
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                allHostels = getAllHostels();
                              });
                            }
                          });
                        },
                        child: Column(
                          children: [
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
                                    errorBuilder: (context, error, stackTrace) => Image.network(
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
                            ),
                            const SizedBox(height: 8.0),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 10,
                              color: Colors.grey[800],
                              shadowColor: Colors.black38,
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
                                        color: Colors.orangeAccent
                                      ),
                                    ),
                                    Text(
                                      hostel.occupancy.toLowerCase(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.tealAccent,
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
