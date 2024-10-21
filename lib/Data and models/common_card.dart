import 'package:flutter/material.dart';


class CommonCard extends StatefulWidget {
  final Color? color;
  final double radius;
  final Widget? child;

  const CommonCard({Key? key, this.color, this.radius = 16, this.child})
      : super(key: key);
  @override
  _CommonCardState createState() => _CommonCardState();
}

class _CommonCardState extends State<CommonCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      //   shadowColor: Theme.of(context).dividerColor,
      color: widget.color,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius),
          //side: BorderSide(color: Colors.tealAccent, width: 1.5)
      ),
      elevation: 50,
      child: widget.child,
    );
  }
}