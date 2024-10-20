import 'package:flutter/gestures.dart';
import 'package:iris_rec/Data%20and%20models/hostel_data.dart';

class StudentList{
  HostelDetails hostelinfo;
  String email;
  String name;
  String rollnumber;
  String uid;
  StudentList({required this.hostelinfo,required this.email,required this.name,required this.rollnumber,required this.uid});
  factory StudentList.fromJson(Map<String, dynamic> json) {
    return StudentList(
      hostelinfo: HostelDetails.fromJson(json['hostelInfo']),
      email: json['email'],
      name : json['name'],
      rollnumber: json['roll'],
      uid : json['uid']
    );
  }

}
class HostelDetails{
  String floor;
  String hostelName;
  String wing;
  String roomNumber;
  HostelDetails({required this.floor,required this.hostelName,required this.roomNumber,required this.wing});
  factory HostelDetails.fromJson(Map<String, dynamic> json) {
    return HostelDetails(
        floor: json['floor'],
        hostelName : json['hostelName'],
        wing : json['wing'],
        roomNumber : json['roomNumber']
    );
  }
}