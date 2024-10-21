import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  final Color? textColor; // Added textColor parameter
  final Color? activeColor;

  const MyListTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.activeColor,
    this.textColor = Colors.white, // Default text color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: activeColor, // Change color when tapped
      highlightColor: activeColor, // Color when held
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.tealAccent, // Icon color
          ),
          title: Text(
            text,
            style: GoogleFonts.poppins(
              color: textColor, // Use provided text color
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}