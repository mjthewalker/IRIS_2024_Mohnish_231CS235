import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_rec/Data%20and%20models/loading_screen.dart';
import 'package:iris_rec/Screens/Student_Manager/manage_student.dart';
import 'package:iris_rec/Screens/Student_Manager/student_search.dart';
import '../../Data and models/student_list_model.dart';

class StudentManager extends StatefulWidget {
  const StudentManager({super.key});

  @override
  StudentManagerState createState() => StudentManagerState();
}

class StudentManagerState extends State<StudentManager> {
  late Future<List<StudentList>> studentData;

  @override
  void initState() {
    super.initState();
    studentData = getAllStudents();
  }

  Future<List<StudentList>> getAllStudents() async {
    List<StudentList> tempList = [];
    try {
      CollectionReference studentsCollection = FirebaseFirestore.instance.collection('users');
      QuerySnapshot hostelsSnapshot = await studentsCollection.get();

      for (var tempdoc in hostelsSnapshot.docs) {
        Map<String, dynamic> studentData = tempdoc.data() as Map<String, dynamic>;
        StudentList student = StudentList.fromJson(studentData);
        tempList.add(student);
      }
    } catch (e) {
      print("Error fetching students: $e");
    }

    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            showSearch(context: context, delegate: StudentSearchDelegate(studentData));
          }, icon: const Icon(Icons.search))
        ],
        title: Text(
          "Student Manager",
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
      body: FutureBuilder<List<StudentList>>(
        future: studentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearLoadingScreen();
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageStudent(studentdata: request),
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        studentData = getAllStudents();
                      });
                    }
                  });
                },
                child: InkWell(
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: const BorderSide(color: Colors.tealAccent, width: 1.5),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black38,
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: Colors.tealAccent,
                        size: 40,
                      ),
                      title: Text(
                        '${request.name}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Current Hostel: ${request.hostelinfo.hostelName}\n',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.tealAccent,
                      ),
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
