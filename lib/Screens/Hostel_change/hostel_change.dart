import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';

import 'hostel_change_details.dart';
import '../../Data and models/hostel_change_model.dart';
class HostelChangeApproval extends StatefulWidget{
    @override
    HostelChangeApprovalState createState() => HostelChangeApprovalState();
}
class HostelChangeApprovalState extends State<HostelChangeApproval>{
  late Future<List<HostelChangeRequest>> allChangeRequests;
  @override
  void initState() {
    super.initState();
    allChangeRequests = getAllRequests();
  }
  Future<List<HostelChangeRequest>> getAllRequests() async {
    List<HostelChangeRequest> allRequests = [];

    try {
      CollectionReference hostelsCollection = FirebaseFirestore.instance.collection('requests');
      QuerySnapshot hostelsSnapshot = await hostelsCollection.get();

      for (var hostelDoc in hostelsSnapshot.docs) {
        // Get the data from each hostel document
        Map<String, dynamic> hostelData = hostelDoc.data() as Map<String, dynamic>;

        // Iterate through each user's data
        hostelData.forEach((userKey, userData) {
          // Check if userData is not null and is a Map
          if (userData is Map<String, dynamic>) {
            // Create a HostelChangeRequest object from each user's data
            HostelChangeRequest request = HostelChangeRequest.fromJson(userData);
            // Add it to the list of all requests
            allRequests.add(request);
          }
        });
      }
    } catch (e) {
      print("Error fetching requests: $e"); // Log the actual error
    }

    return allRequests;
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hostel change Requests"),
      ),
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<List<HostelChangeRequest>>(
        future: allChangeRequests, // Fetching data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: GFLoader(
                type:GFLoaderType.ios
            ),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Requests Found'));
          }

          List<HostelChangeRequest> requests = snapshot.data!;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              HostelChangeRequest request = requests[index];
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HostelChangeFinalApproval(finalData: request,)),
                  ).then((value){
                    if (value!=null){
                      setState(() {
                        allChangeRequests = getAllRequests();
                      });
                    }
                  });
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Name: ${request.personalDetails.name}'),
                    subtitle: Text('Current Hostel: ${request.hostelChangeDetails.currentDetails.currentHostel}\n'
                        'New Hostel: ${request.hostelChangeDetails.newRoomDetails.newHostel}'),
                    trailing: Text('Status: ${request.status}'),
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