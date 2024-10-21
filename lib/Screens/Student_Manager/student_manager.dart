import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:iris_rec/Screens/Student_Manager/manage_student.dart';

import '../../Data and models/student_list_model.dart';

class StudentManager extends StatefulWidget {
  const StudentManager({super.key});

  @override
  StudentManagerState createState() => StudentManagerState();
}

class StudentManagerState extends State<StudentManager> {
  late Future<List<StudentList>> studentData;

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

        // Directly create the StudentList object without null check
        StudentList student = StudentList.fromJson(studentData);
        tempList.add(student);
      }
    } catch (e) {
      // Log the actual error for better debugging
      print("Error fetching students: $e");
    }

    return tempList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Student Manager",

          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent, // Accent color for title
          ),
        ),
        backgroundColor: Colors.grey[900], // Dark background for AppBar
        iconTheme: const IconThemeData(color: Colors.tealAccent), // Accent color for icons
      ),
      backgroundColor: Colors.grey[850], // Dark background for the main body
      body: FutureBuilder<List<StudentList>>(
        future: studentData, // Fetching data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: GFLoader(
                type: GFLoaderType.ios,
              ),
            );
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
                    color: Colors.grey[900], // Dark card background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0), // Rounded corners for cards
                      side: BorderSide(color: Colors.tealAccent, width: 1.5), // Accent color border
                    ),
                    elevation: 8, // Card elevation for shadow effect
                    shadowColor: Colors.black38, // Subtle shadow color
                    child: ListTile(
                      leading: const Icon(
                        Icons.person, // Person icon
                        color: Colors.tealAccent, // Accent color for the icon
                        size: 40, // Size of the icon
                      ),
                      title: Text(
                        'Name: ${request.name}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent, // Accent color for title
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0), // Add some space above the subtitle
                        child: Text(
                          'Current Hostel: ${request.hostelinfo.hostelName}\n',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white, // Light text color for readability
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios, // Optional: Add a forward arrow to indicate navigation
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
