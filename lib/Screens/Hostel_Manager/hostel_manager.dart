import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iris_rec/Screens/Hostel_Manager/add_hostel.dart';
import 'package:iris_rec/Screens/Hostel_Manager/hostel_info.dart';

import '../../Data and models/common_card.dart';
import '../../Data and models/hostel_data.dart';

class HostelManager extends StatefulWidget{
  @override
  HostelManagerState createState() => HostelManagerState();
}
class HostelManagerState extends State<HostelManager>{
  late Box<Hostel> hostelBox; // Define your hostel box
  late Future<List<Hostel>> allHostels;
  @override
  void initState() {
    super.initState();
    hostelBox = Hive.box<Hostel>('hostelBox5'); // Initialize your Hive box
    allHostels = getAllHostels(); // Call the function to get hostels
  }
  Future<List<Hostel>> getAllHostels() async {
    List<Hostel> hostels = await HostelDataBase(hostelBox).getAllHostels();
    return hostels;
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Hostel Manager"),
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

          return
                  Column(
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => HostelLayoutForm(), // Pass the hostel object
                        )).then((value){
                          if (value!=null){
                            setState(() {
                              allHostels = getAllHostels();
                            });
                          }
                        });
                      }, child: Text("Add New Hostel")),


                      Expanded(
                                  child: ListView.builder(
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
                              builder: (context) => HostelInfo(hostelName: hostel.hostelName,hostelBox: hostelBox,), // Pass the hostel object
                            ),
                          ).then((value){
                            if (value!=null){
                              setState(() {
                                allHostels = getAllHostels();
                              });
                            }
                          });
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
                                  ),
                                ),
                    ],
                  );
        },
      ),
    );
  }
}