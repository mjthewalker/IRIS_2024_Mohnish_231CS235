import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data and models/student_list_model.dart';
import 'manage_student.dart';

class StudentSearchDelegate extends SearchDelegate<StudentList> {
  final Future<List<StudentList>> studentDataFuture;

  StudentSearchDelegate(this.studentDataFuture);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildStudentList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildStudentList(context);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.tealAccent),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey[500]),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.tealAccent,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildStudentList(BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: FutureBuilder<List<StudentList>>(
        future: studentDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: GFLoader(type: GFLoaderType.ios),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          final List<StudentList> results = snapshot.data!.where((student) {
            final studentName = student.name.toLowerCase();
            final searchQuery = query.toLowerCase();
            return studentName.contains(searchQuery);
          }).toList();

          if (results.isEmpty) {
            return const Center(child: Text('No results found.', style: TextStyle(color: Colors.tealAccent),));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final student = results[index];

              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageStudent(studentdata: student),
                    ),
                  );
                },
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
                      student.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Current Hostel: ${student.hostelinfo.hostelName}\n',
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
              );
            },
          );
        },
      ),
    );
  }
}
