import 'package:flutter/material.dart';
import 'package:iris_rec/Data%20and%20models/my_list_tile.dart';

class MyDrawer extends StatelessWidget{
  final void Function()? onSignOut;
  final void Function()? myRequests;
  final void Function()? hostelRequests;
  final void Function()? hostelManager;
  final void Function()? studentManager;
  final String? isAdmin;

  const MyDrawer({super.key,this.onSignOut,this.myRequests,this.hostelRequests,this.hostelManager,this.studentManager, this.isAdmin});

  @override
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(


        children: [
            DrawerHeader(
               child: Icon(
                 Icons.person,
                 color: Colors.white,
                 size: 64,
               )),

          MyListTile(icon: Icons.home, text: 'H O M E', onTap:() => Navigator.pop(context)),
          const SizedBox(height: 10,),
          if (isAdmin == "admin") Column(
            children: [
              MyListTile(icon: Icons.airplane_ticket_outlined, text: 'M A N A G E  L E A V E S', onTap : myRequests),
              const SizedBox(height: 10,),
              MyListTile(icon: Icons.receipt_long, text: 'H O S T E L  R E Q U E S T S', onTap : hostelRequests),
              const SizedBox(height: 10,),
              MyListTile(icon: Icons.business, text: 'H O S T E L  M A N A G E R', onTap : hostelManager),
              const SizedBox(height: 10,),
              MyListTile(icon: Icons.people, text: 'S T U D E N T  M A N A G E R', onTap : studentManager),
              const SizedBox(height: 10,),
            ],),

          MyListTile(icon: Icons.logout, text: 'L O G O U T', onTap: onSignOut)




        ],
      ),

    );
  }
}