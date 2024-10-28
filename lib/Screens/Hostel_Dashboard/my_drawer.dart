import 'package:flutter/material.dart';
import 'package:iris_rec/Data%20and%20models/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onSignOut;


  final String? isAdmin;

  const MyDrawer({
    super.key,
    this.onSignOut,

    this.isAdmin,

  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[900],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  children: [
                    Image.asset('assets/images/logonitk.jpg', scale: 5),
                    const SizedBox(width: 25),
                    Container(width: 1, height: 60, color: Colors.tealAccent),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.person,
                      color: Colors.tealAccent,
                      size: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            textColor: Colors.white,
            activeColor: Colors.tealAccent,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 10),
          if (isAdmin == "admin") ...[
            MyListTile(
              icon: Icons.airplane_ticket_outlined,
              text: 'M A N A G E  L E A V E S',
              textColor: Colors.white,
              activeColor: Colors.tealAccent,
              onTap: (){
                Navigator.pushNamed(context, '/manageLeaves');
              },
            ),
            const SizedBox(height: 10),
            MyListTile(
              icon: Icons.receipt_long,
              text: 'H O S T E L  R E Q U E S T S',
              textColor: Colors.white,
              activeColor: Colors.tealAccent,
              onTap: (){
                Navigator.pushNamed(context, '/hostelChangeApproval');
              },
            ),
            const SizedBox(height: 10),
            MyListTile(
              icon: Icons.business,
              text: 'H O S T E L  M A N A G E R',
              textColor: Colors.white,
              activeColor: Colors.tealAccent,
              onTap: (){
                Navigator.pushNamed(context, '/hostelManager');
              },
            ),
            const SizedBox(height: 10),
            MyListTile(
              icon: Icons.people,
              text: 'S T U D E N T  M A N A G E R',
              textColor: Colors.white,
              activeColor: Colors.tealAccent,
              onTap: (){
                Navigator.pushNamed(context, '/studentManager');
              },
            ),
            const SizedBox(height: 10),
            MyListTile(
              icon: Icons.people,
              text: 'S W I T C H  R E Q U E S T S',
              textColor: Colors.white,
              activeColor: Colors.tealAccent,
              onTap: (){
                Navigator.pushNamed(context, '/approveSwitch');
              },
            ),
            const SizedBox(height: 10),
          ],
          MyListTile(
            icon: Icons.logout,
            text: 'L O G O U T',
            textColor: Colors.white,
            activeColor: Colors.tealAccent,
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
