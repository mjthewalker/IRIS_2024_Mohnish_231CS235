import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplyLeave extends StatefulWidget {
  final String hostelName;
  const ApplyLeave({super.key, required this.hostelName});

  @override
  ApplyLeaveState createState() => ApplyLeaveState();
}

class ApplyLeaveState extends State<ApplyLeave> {
  final _formKey = GlobalKey<FormState>();
  String _nameController = '';
  String _leaveReasonController = '';
  String _roll = '';
  DateTime? _fromDate;
  DateTime? _toDate;


  Future<void> _pickDate(BuildContext context, Function(DateTime?) setDate, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setDate(picked);
    }
  }


  void _submitForm(BuildContext context) async {
    _formKey.currentState!.save();
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both From and To dates!")),
      );
      return;
    }
    await FirebaseFirestore.instance.collection('leaves').doc(widget.hostelName).set({
      "$_roll": {
        "name": _nameController,
        "status": "yet to be approved",
        "FromDate": _fromDate,
        "ToDate": _toDate,
        "Reason": _leaveReasonController,
        "rollNumber": _roll,
        "hostel": widget.hostelName,
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Leave applied successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Apply for Leave",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[

              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",

                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nameController = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),


              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Roll Number",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your roll number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _roll = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _fromDate == null
                        ? 'Select From date'
                        : 'From Date: ${_fromDate!}'.substring(0, 20),
                    style: const TextStyle(color: Colors.tealAccent),
                  ),
                  IconButton(onPressed: () {
                    _pickDate(context, (pickedDate) {
                      setState(() {
                        _fromDate = pickedDate;
                      });
                    }, _fromDate);
                  }, icon: const Icon(Icons.calendar_month,color: Colors.tealAccent,))

                ],
              ),
              const SizedBox(height: 20),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _toDate == null
                        ? 'Select To date'
                        : "To Date: ${_toDate!}".substring(0, 20)
                    ,
                    style: const TextStyle(color: Colors.tealAccent),
                  ),
                  IconButton(onPressed: () {
                    _pickDate(context, (pickedDate) {
                      setState(() {
                        _toDate = pickedDate;
                      });
                    }, _toDate);
                  }, icon: const Icon(Icons.calendar_month,color: Colors.tealAccent,))

                ],
              ),
              const SizedBox(height: 20),


              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: TextFormField(

                  decoration: const InputDecoration(
                    labelText: "Reason for Leave",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16),
                  ),

                  style: const TextStyle(color: Colors.white),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a reason for leave';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _leaveReasonController = value!;
                  },
                ),
              ),
              const SizedBox(height: 40),


              ElevatedButton(
                onPressed: () {
                  if (_fromDate == null || _toDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select both From and To dates!")),
                    );
                  } else if (_fromDate!.isAfter(_toDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("From Date cannot be after To Date!")),
                    );
                  } else {
                    _submitForm(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners for button
                  ),
                ),
                child:  Text('Submit',style: TextStyle(color: Colors.grey[900]),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
