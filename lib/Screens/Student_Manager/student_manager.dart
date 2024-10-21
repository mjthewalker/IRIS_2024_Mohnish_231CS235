import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Screens/Student_Manager/manage_student.dart';

import '../../Data and models/student_list_model.dart';

class StudentManager extends StatefulWidget{
  const StudentManager({super.key});

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
          title: Text(
              "Student Manager",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          backgroundColor: Colors.grey[900],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<List<StudentList>>(
          future: studentData, // Fetching data
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

            List<StudentList> requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                StudentList request = requests[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageStudent(studentdata: request)),
                    ).then((value){
                      if (value!=null){
                        setState(() {
                          studentData = getAllStudents();
                        });
                      }
                    });

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


