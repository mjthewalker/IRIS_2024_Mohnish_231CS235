import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data and models/student_list_model.dart';
import 'manage_student.dart';

class StudentSearchDelegate extends SearchDelegate<StudentList> {
  final Future<List<StudentList>> studentDataFuture;

  // Constructor that accepts the Future with student list data
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

    // Same widget is used for both results and suggestions
    return _buildStudentList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Same widget is used for both results and suggestions
    return _buildStudentList(context);
  }
  @override
  ThemeData appBarTheme(BuildContext context) {
    // Customize the AppBar theme to modify the search bar's appearance
    return ThemeData(
      // Set the background color of the AppBar (search bar container)
      appBarTheme:  AppBarTheme(
        backgroundColor: Colors.grey[900], // White search bar
        iconTheme: const IconThemeData(color: Colors.tealAccent), // Icon color
      ),
      // Customizing the appearance of the search input field
      inputDecorationTheme: InputDecorationTheme(

        hintStyle: TextStyle(color: Colors.grey[500]), // Placeholder text color
        border: InputBorder.none, // No border in search bar
      ),
      textTheme: const TextTheme(
        // Text color in the search bar
        titleLarge: TextStyle(
          color: Colors.tealAccent, // Black text in the search bar
          fontSize: 18,
        ),
      ),
    );
  }
  // Common method to build student list based on query
  Widget _buildStudentList(BuildContext context) {
    // Use FutureBuilder to get the data from the Future
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

          // Filter the loaded student data based on the search query
          final List<StudentList> results = snapshot.data!.where((student) {
            final studentName = student.name.toLowerCase();
            final searchQuery = query.toLowerCase();
            return studentName.contains(searchQuery);
          }).toList();

          if (results.isEmpty) {
            return const Center(child: Text('No results found.',style: TextStyle(color: Colors.tealAccent),));
          }

          return
             ListView.builder(
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
                  child: InkWell(

                    child: Card(

                      margin: const EdgeInsets.all(10),
                      color: Colors.grey[900],
                      // Dark card background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0), // Rounded corners for cards
                        side: const BorderSide(color: Colors.tealAccent, width: 1.5), // Accent color border
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
                          student.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent, // Accent color for title
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0), // Add some space above the subtitle
                          child: Text(
                            'Current Hostel: ${student.hostelinfo.hostelName}\n',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white, // Light text color for readability
                            ),
                          ),
                        ),
                        trailing: const Icon(
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
