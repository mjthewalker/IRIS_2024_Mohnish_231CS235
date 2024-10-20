import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iris_rec/Data%20and%20models/student_list_model.dart';

class ApplyLeave extends StatefulWidget {
  String hostelName;
  ApplyLeave({required this.hostelName});

  @override
  _ApplyLeaveState createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final _formKey = GlobalKey<FormState>();
  var _nameController = '';
  var _leaveReasonController = '';
  var _roll = '';
  DateTime? _fromDate;
  DateTime? _toDate;

  @override


  // Method to handle date picker for both 'from' and 'to' dates
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

  // Method to handle form submission
  void _submitForm(BuildContext context) async {
        _formKey.currentState!.save();
      if (_fromDate == null || _toDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select both From and To dates!")),
        );
        return;
      }
      await FirebaseFirestore.instance.collection('leaves').doc(widget.hostelName).set({
        "$_roll":{
          "name" : _nameController,
          "status" : "yet to be approved",
          "FromDate" : _fromDate,
          "ToDate" : _toDate,
          "Reason" : _leaveReasonController,
          "rollNumber" : _roll,
          "hostel" : widget.hostelName
        }

      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Leave applied successfully!")),
      );
      Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for Leave"),
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Name field
              TextFormField(

                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nameController = value!;
                }
              ),
              SizedBox(height: 20),
              TextFormField(

                  decoration: InputDecoration(
                    labelText: "Roll Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _roll = value!;
                  }
              ),
              // From date picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _fromDate == null
                        ? 'Select From date'
                        : 'From Date: ${_fromDate!.toLocal()}'.split(' ')[0],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _pickDate(context, (pickedDate) {
                        setState(() {
                          _fromDate = pickedDate;
                        });
                      }, _fromDate);
                    },
                    child: Text('Pick From Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // To date picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _toDate == null
                        ? 'Select To date'
                        : 'To Date: ${_toDate!.toLocal()}'.split(' ')[0],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _pickDate(context, (pickedDate) {
                        setState(() {
                          _toDate = pickedDate;
                        });
                      }, _toDate);
                    },
                    child: Text('Pick To Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Leave reason field
              TextFormField(

                decoration: InputDecoration(
                  labelText: "Reason for Leave",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a reason for leave';
                  }
                  return null;
                },
                onSaved: (value){
                  _leaveReasonController =value!;
                },
              ),
              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_fromDate == null || _toDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select both From and To dates!")),
                    );
                  } else if (_fromDate!.isAfter(_toDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("From Date cannot be after To Date!")),
                    );
                  } else {
                    _submitForm(context);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
