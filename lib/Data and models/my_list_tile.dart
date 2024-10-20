import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class MyListTile extends StatelessWidget{
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const MyListTile({
    required this.icon,required this.text,required this.onTap
  });
  @override
  Widget build(BuildContext context){
    return Padding(
        padding: const EdgeInsets.only(left : 4.0),
        child: ListTile(
              leading: Icon(
            icon,
            color : Colors.white,
    ),
        onTap: onTap,
        title: Text(
          text,
        style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w400)),
    ),
    );
  }
}