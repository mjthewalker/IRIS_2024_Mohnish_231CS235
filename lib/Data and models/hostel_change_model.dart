class HostelChangeRequest {
  HostelChangeDetails hostelChangeDetails;
  PersonalDetails personalDetails;
  String status;

  HostelChangeRequest({
    required this.hostelChangeDetails,
    required this.personalDetails,
    required this.status,
  });

  // Factory constructor to create an instance from a Map (JSON)
  factory HostelChangeRequest.fromJson(Map<String, dynamic> json) {
    return HostelChangeRequest(
      hostelChangeDetails: HostelChangeDetails.fromJson(json['HostelChangeDetails']),
      personalDetails: PersonalDetails.fromJson(json['PersonalDetails']),
      status: json['Status'],
    );
  }
}

class PersonalDetails {
  String name;
  String roll;
  String email;
  String uid;
  PersonalDetails({
    required this.name,
    required this.roll,
    required this.email,
    required this.uid
  });

  factory PersonalDetails.fromJson(Map<String, dynamic> json) {
    return PersonalDetails(
      name: json['name'],
      roll : json['rollNumber'],
      email : json['email'],
      uid  : json['uid']
    );
  }
}

class HostelChangeDetails {
  CurrentDetails currentDetails;
  NewRoomDetails newRoomDetails;

  HostelChangeDetails({
    required this.currentDetails,
    required this.newRoomDetails,
  });

  factory HostelChangeDetails.fromJson(Map<String, dynamic> json) {
    return HostelChangeDetails(
      currentDetails: CurrentDetails.fromJson(json['CurrentDetails']),
      newRoomDetails: NewRoomDetails.fromJson(json['NewRoomDetails']),
    );
  }
}

class CurrentDetails {
  String currentFloor;
  String currentHostel;
  String currentRoom;
  String currentWing;

  CurrentDetails({
    required this.currentFloor,
    required this.currentHostel,
    required this.currentRoom,
    required this.currentWing,
  });

  factory CurrentDetails.fromJson(Map<String, dynamic> json) {
    return CurrentDetails(
      currentFloor: json['currentFloor'],
      currentHostel: json['currentHostel'],
      currentRoom: json['currentRoom'],
      currentWing: json['currentWing'],
    );
  }
}

class NewRoomDetails {
  String newFloor;
  String newHostel;
  String newRoom;
  String newWing;

  NewRoomDetails({
    required this.newFloor,
    required this.newHostel,
    required this.newRoom,
    required this.newWing,
  });

  factory NewRoomDetails.fromJson(Map<String, dynamic> json) {
    return NewRoomDetails(
      newFloor: json['floor'],
      newHostel: json['changetoHostel'],
      newRoom: json['roomNumber'],
      newWing: json['wing'],
    );
  }
}
