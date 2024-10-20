import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Data and models/student_list_model.dart';

class StudentManager extends StatefulWidget{
  @override
  StudentManagerState createState() => StudentManagerState();
}
class StudentManagerState extends State<StudentManager>{
  late Future<List<StudentList>> studentData;
  void initState() {
    super.initState();
    studentData = getAllStudents();
  }
  Future<List<StudentList>> getAllStudents() async{
    List<StudentList> tempList = [];
    try{
      CollectionReference studentsCollection = FirebaseFirestore.instance.collection('users');
      QuerySnapshot hostelsSnapshot = await studentsCollection.get();
      for (var tempdoc in hostelsSnapshot.docs){
        Map<String,dynamic> studentData = tempdoc.data() as Map<String,dynamic>;

        if (studentData!=null){
          StudentList student = StudentList.fromJson(studentData);
          tempList.add(student);
        }
      }
    }catch (e){
      print("error ");
    }

    return tempList;
  }
  @override
  Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          title: Text("Student Manager"),
        ),
        backgroundColor: Colors.grey[300],
        body: FutureBuilder<List<StudentList>>(
          future: studentData, // Fetching data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Requests Found'));
            }

            List<StudentList> requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                StudentList request = requests[index];
                return GestureDetector(
                  onTap: (){
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HostelChangeFinalApproval(finalData: request,)),
                    ).then((value){
                      if (value!=null){
                        setState(() {
                          allChangeRequests = getAllRequests();
                        });
                      }
                    });*/
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Name: ${request.name}'),
                      subtitle: Text('Current Hostel: ${request.hostelinfo.hostelName}\n'
                          ),

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


