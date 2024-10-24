import 'package:flutter/material.dart';
import 'package:iris_rec/Data%20and%20models/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onSignOut;
  final void Function()? myRequests;
  final void Function()? hostelRequests;
  final void Function()? hostelManager;
  final void Function()? studentManager;
  final void Function()? switchRequests;

  final String? isAdmin;

  const MyDrawer({
    Key? key,
    this.onSignOut,
    this.myRequests,
    this.hostelRequests,
    this.hostelManager,
    this.studentManager,
    this.isAdmin,
    this.switchRequests,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900], // Dark background for the drawer
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[850], // Slightly lighter for the header
            ),
            child: Center(
              child: Icon(
                Icons.person,
                color: Colors.tealAccent, // Accent color for the icon
                size: 64,
              ),
            ),
          ),
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            textColor: Colors.white,
            activeColor: Colors.tealAccent, // Change color on tap
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 10),
          if (isAdmin == "admin") ...[
            MyListTile(
              icon: Icons.airplane_ticket_outlined,
              text: 'M A N A G E  L E A V E S',
              textColor: Colors.white,
              activeColor: Colors.tealAccent, // Change color on tap
              onTap: myRequests,
            ),
            const SizedBox(height: 10),
            MyListTile(
              icon: Icons.receipt_long,
              text: 'H O S T E L  R E Q U E S T S',
              textColor: Colors.white,
              activeColor: Colors.tealAccent, // Change color on tap
              onTap: hostelRequests,
            ),
            const SizedBox(height: 10),
            MyListTile(
              icon: Icons.business,
              text: 'H O S T E L  M A N A G E R',
              textColor: Colors.white,
              activeColor: Colors.tealAccent, // Change color on tap
              onTap: hostelManager,
            ),
            const SizedBox(height: 10),
            MyListTile(
              icon: Icons.people,
              text: 'S T U D E N T  M A N A G E R',
              textColor: Colors.white,
              activeColor: Colors.tealAccent, // Change color on tap
              onTap: studentManager,
            ),
            const SizedBox(height: 10),
            MyListTile(
              icon: Icons.people,
              text: 'S W I T C H  R E Q U E S T S',
              textColor: Colors.white,
              activeColor: Colors.tealAccent, // Change color on tap
              onTap: switchRequests,
            ),
            const SizedBox(height: 10),
          ],

          MyListTile(
            icon: Icons.logout,
            text: 'L O G O U T',
            textColor: Colors.white,
            activeColor: Colors.tealAccent, // Change color on tap
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}