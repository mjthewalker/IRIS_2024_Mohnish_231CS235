import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Data%20and%20models/student_list_model.dart';
import '../../Data and models/hostel_data.dart'; // Make sure to import your Hostel model
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Data and models/loading_screen.dart';
import '../Hostel_Dashboard/bloc/iris_bloc.dart';

class HostelDetailScreen extends StatefulWidget {
  final Hostel hostel; // Receive hostel object
  final String mode;
  final Map<String,dynamic>? currentDetails;
  final StudentList studentdetail;
  final String? name;
  final String? roll;
  const HostelDetailScreen({super.key, required this.hostel,required this.mode, this.currentDetails,this.name,this.roll,required this.studentdetail});

  @override
  State<HostelDetailScreen> createState() => _HostelDetailScreenState();
}

class _HostelDetailScreenState extends State<HostelDetailScreen> {
  String? selectedRoom;
  String? room;
  num i = 0;
  num x = 0;
  int occupancyRoom=0;
  int occupiedRoomsCount = 0;
  Map<String, int> roomData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllRooms();
  }

  Future<void> _fetchAllRooms() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('hostels')
          .doc(widget.hostel.hostelName)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        Map<String, int> fetchedData = {};
        int occupiedCount = 0;

        for (var floor in widget.hostel.floors) {
          for (var wing in floor.wings) {
            String floorNumber = "Floor ${floor.floorNumber}";
            Map<String, dynamic>? wingData = data[floorNumber]?[wing.wingName];
            if (wingData != null) {
              wingData.forEach((roomKey, value) {
                if (roomKey.startsWith('Room')) {
                  fetchedData[roomKey] = value ?? 0;
                  if (widget.hostel.occupancy=="doubleSharing"){
                    if (value != null && value >=2) {
                      occupiedCount++;

                    }
                  }
                  else{
                    if (value != null && value >= 3) {
                      occupiedCount++;
                    }
                  }

                }
              });
            }
          }
        }

        setState(() {
          roomData = fetchedData;
          occupiedRoomsCount = occupiedCount;

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  void _submit() async{
    if (selectedRoom == null){
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please Select a room')));  return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Submission'),
          content: Text('Are you sure you want to book $selectedRoom?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );


    if (confirm == false) return;
    User? user = FirebaseAuth.instance.currentUser;
    List<String> parts = selectedRoom!.split(',');
    String floorPart = parts[0].trim();  // "Floor 1"
    String floorNumber = floorPart.split(' ')[1]; // Extract "1"
    String wingName = parts[1].trim();

    if (widget.mode == "change" && widget.currentDetails!=null){
      await FirebaseFirestore.instance.collection('requests').doc(widget.hostel.hostelName).update({
        user!.email!.split('.').first:{
          "HostelChangeDetails":{
            "CurrentDetails":{
              "currentHostel" : widget.currentDetails!['hostelName'],
              "currentFloor" : widget.currentDetails!['floor'],
              "currentWing"  : widget.currentDetails!['wing'],
              "currentRoom"  : widget.currentDetails!['roomNumber'],
            },
            "NewRoomDetails" :{
              "changetoHostel" : widget.hostel.hostelName,
              "roomNumber" : selectedRoom!.split('Room').last.trim(),
              "wing" : wingName,
              "floor" : floorNumber,
            }
          },
          "PersonalDetails" : {
            "name" : widget.name,
            "rollNumber" : widget.roll,
            "email" : user.email!.split('.').first,
            "uid"  : user.uid
          },
          "Status" : "Pending"
        }});
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Request Sent')));
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    var userid = user!.uid;
    if (widget.mode == "realloc")  userid = widget.studentdetail.uid;
    await FirebaseFirestore.instance.collection('users').doc(userid).update({
      "hostelInfo":{
        "hostelName" : widget.hostel.hostelName,
        "floor" : floorNumber,
        "roomNumber" : selectedRoom!.split('Room').last.trim(),
        "wing" : wingName,
      }
    });
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(widget.hostel.hostelName)
        .set({
      floorPart: {
        wingName: {
          "Room ${selectedRoom!.split('Room').last.trim()}": FieldValue.increment(1)
        }
      }
    }, SetOptions(merge: true));
    if (widget.mode == "realloc"){

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('student reallocated')));
      Navigator.of(context).popUntil((route) => route.isFirst);
      final homeBloc = context.read<HomeBloc>();
      homeBloc.add(LoadData());
      return;

    }
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadData());
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        centerTitle: true,

        title: Text(
            "Select a room in ${widget.hostel.hostelName}",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            )),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      body: isLoading
          ? LinearLoadingScreen()
          : Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),

            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Available rooms : ${widget.hostel.floors[0].wings[0].availableRooms*widget.hostel.floors.length*2-occupiedRoomsCount}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),


                          selectedRoom == null
                              ? const Text("")
                              : Text(
                            "Selected Room : ${selectedRoom!.split('Room').last.trim()}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[900],
                            )),

                          selectedRoom == null
                              ? const Text("") :
                          Text(
                              "Occupancy : ${occupancyRoom}/3",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[900],
                              )),


                    ],
                  ),
                ),
                const SizedBox(width: 90,),
                ElevatedButton(onPressed: _submit,
                      style:  ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Book Room',
                        style: GoogleFonts.poppins(
                          fontSize:10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),
                    ),

              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.hostel.floors.length,
              itemBuilder: (context, index) {
                final floor = widget.hostel.floors[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      const SizedBox(height: 10,),

                       Text(
                        'Floor ${floor.floorNumber}',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[900]
                            ,fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    Divider(
                      height: 20,
                      thickness: 1.5,
                      color: Colors.grey[900],

                    ),
                    Column(
                      children: floor.wings.map((wing) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                wing.wingName,
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[900],
                                    fontSize: 15
                                    ,fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: wing.availableRooms,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, roomIndex) {
                                x = roomIndex + 1;
                                if (floor.floorNumber>0) {
                                  x = roomIndex + 1 + (floor.floorNumber * (widget.hostel.floors[index-1].wings[0].availableRooms +widget.hostel.floors[index-1].wings[1].availableRooms )) ;
                                }
                                if (wing.wingName == "Left Wing") x += widget.hostel.floors[index].wings[0].availableRooms;
                                room = x.toString();
                                String roomKey = 'Room $room';

                                int occupancy = roomData[roomKey] ?? 0;


                                bool isAvailable = occupancy == 0 || occupancy == 1 || occupancy == 2;
                                if (widget.hostel.occupancy=="doubleSharing"){
                                  isAvailable = occupancy == 0 || occupancy == 1;
                                }


                                String roomId =
                                    "Floor ${floor.floorNumber}, ${wing.wingName}, Room $room";

                                return GestureDetector(
                                  onTap: isAvailable
                                      ? () {
                                    setState(() {
                                      selectedRoom = roomId;
                                      occupancyRoom = occupancy;

                                    });
                                  }
                                      : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedRoom == roomId
                                          ? Colors.greenAccent
                                          : isAvailable
                                          ? Colors.white
                                          : Colors.red,
                                      border: Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${room}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[900]
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );

                      }).toList(),
                    ),
                    const SizedBox(height: 10,),

                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
