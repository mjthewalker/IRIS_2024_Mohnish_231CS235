import 'package:hive/hive.dart';

part 'hostel_data.g.dart';  // Ensure you generate this part file using build_runner

@HiveType(typeId: 0)
class Wing {
  @HiveField(0)
  final String wingName;

  @HiveField(1)
  final int capacity;

  @HiveField(2)
  final int availableRooms;

  Wing({
    required this.wingName,
    required this.capacity,
    required this.availableRooms,
  });
}

@HiveType(typeId: 1)
class Floor {
  @HiveField(0)
  final int floorNumber;

  @HiveField(1)
  final List<Wing> wings;

  Floor({
    required this.floorNumber,
    required this.wings,
  });
}

@HiveType(typeId: 2)
class Hostel {
  @HiveField(0)
  final String hostelName;

  @HiveField(1)
  final List<Floor> floors;

  @HiveField(2)
  final String wardenId;

  @HiveField(3)
  final String imgSrc;
  @HiveField(4)
  final String occupancy;

  Hostel({
    required this.hostelName,
    required this.floors,
    required this.wardenId,
    required this.imgSrc,
    required this.occupancy
  });
}
class HostelDataBase {
  late Box<Hostel> hostelBox;
  HostelDataBase(this.hostelBox);
  Future<void>  storeHostelDataOnce() async {
    // Check if the hostel data already exists
    if (hostelBox.isEmpty) {
      List<Wing> wingsFloor0 = [
        Wing(wingName: "Right Wing", capacity: 30, availableRooms: 10),
        Wing(wingName: "Left Wing", capacity: 30, availableRooms: 10),
      ];
      List<Wing> wingsFloor1 = [
        Wing(wingName: "Right Wing", capacity: 30, availableRooms: 10),
        Wing(wingName: "Left Wing", capacity: 30, availableRooms: 10),
      ];
      List<Wing> wingsFloor2 = [
        Wing(wingName: "Right Wing", capacity: 30, availableRooms: 10),
        Wing(wingName: "Left Wing", capacity: 30, availableRooms: 10),
      ];
      List<Wing> wingsFloor3 = [
        Wing(wingName: "Right Wing", capacity: 30, availableRooms: 10),
        Wing(wingName: "Left Wing", capacity: 30, availableRooms: 10),
      ];
      List<Wing> wingsFloor4 = [
        Wing(wingName: "Right Wing", capacity: 30, availableRooms: 10),
        Wing(wingName: "Left Wing", capacity: 30, availableRooms: 10),
      ];
      List<Wing> wingsFloor5 = [
        Wing(wingName: "Right Wing", capacity: 30, availableRooms: 10),
        Wing(wingName: "Left Wing", capacity: 30, availableRooms: 10),
      ];
      List<Wing> wingsFloor6 = [
        Wing(wingName: "Right Wing", capacity: 30, availableRooms: 10),
        Wing(wingName: "Left Wing", capacity: 30, availableRooms: 10),
      ];
      List<Wing> wingsFloor7 = [
        Wing(wingName: "Right Wing", capacity: 30, availableRooms: 10),
        Wing(wingName: "Left Wing", capacity: 30, availableRooms: 10),
      ];

      List<Floor> floors = [
        Floor(floorNumber: 0, wings: wingsFloor0),
        Floor(floorNumber: 1, wings: wingsFloor1),
        Floor(floorNumber: 2, wings: wingsFloor2),
        Floor(floorNumber: 3, wings: wingsFloor3),
        Floor(floorNumber: 4, wings: wingsFloor4),
        Floor(floorNumber: 5, wings: wingsFloor5),
        Floor(floorNumber: 6, wings: wingsFloor6),
        Floor(floorNumber: 7, wings: wingsFloor7),
      ];

      Hostel hostel = Hostel(
        hostelName: 'Shivalik',
        floors: floors,
        wardenId: 'admin123',
        imgSrc: 'assets/images/shivalik.jpg',
        occupancy: 'tripleSharing'
      );
      List<Wing> wingsFloors0 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloors1 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloors2 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Floor> floors1 = [
        Floor(floorNumber: 0, wings: wingsFloors0),
        Floor(floorNumber: 1, wings: wingsFloors1),
        Floor(floorNumber: 2, wings: wingsFloors2),

      ];

      Hostel hostel1 = Hostel(
          hostelName: 'Sahyadri',
          floors: floors1,
          wardenId: 'admin123',
          imgSrc: 'assets/images/sahyadri.jpg',
          occupancy: 'tripleSharing'
      );
      List<Wing> wingsFloork0 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloork1 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloork2 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Floor> floors2 = [
        Floor(floorNumber: 0, wings: wingsFloork0),
        Floor(floorNumber: 1, wings: wingsFloork1),
        Floor(floorNumber: 2, wings: wingsFloork2),

      ];

      Hostel hostel2 = Hostel(
          hostelName: 'Karavali',
          floors: floors2,
          wardenId: 'admin123',
          imgSrc: 'assets/images/karavali.jpg',
          occupancy: 'tripleSharing'
      );
      List<Wing> wingsFloort0 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloort1 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloort2 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Floor> floors3 = [
        Floor(floorNumber: 0, wings: wingsFloort0),
        Floor(floorNumber: 1, wings: wingsFloort1),
        Floor(floorNumber: 2, wings: wingsFloort2),

      ];

      Hostel hostel3 = Hostel(
          hostelName: 'Trishul',
          floors: floors3,
          wardenId: 'admin123',
          imgSrc: 'assets/images/trishul.jpg',
          occupancy: 'doubleSharing'
      );
      List<Wing> wingsFloora1 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloora2 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloora3 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Floor> floors4 = [
        Floor(floorNumber: 0, wings: wingsFloora1),
        Floor(floorNumber: 1, wings: wingsFloora2),
        Floor(floorNumber: 2, wings: wingsFloora3),

      ];

      Hostel hostel4 = Hostel(
          hostelName: 'Aravali',
          floors: floors4,
          wardenId: 'admin123',
          imgSrc: 'assets/images/Aravali.jpg',
          occupancy : 'tripleSharing'
      );
      List<Wing> wingsFloorv1 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloorv2 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloorv3 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Floor> floors5 = [
        Floor(floorNumber: 0, wings: wingsFloorv1),
        Floor(floorNumber: 1, wings: wingsFloorv2),
        Floor(floorNumber: 2, wings: wingsFloorv3),

      ];

      Hostel hostel5 = Hostel(
          hostelName: 'Vindhya',
          floors: floors5,
          wardenId: 'admin123',
          imgSrc: 'assets/images/vindhya.jpg',
          occupancy : 'doubleSharing'
      );
      List<Wing> wingsFloorsa1 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloorsa2 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Wing> wingsFloorsa3 = [
        Wing(wingName: "Right Wing", capacity: 60, availableRooms: 20),
        Wing(wingName: "Left Wing", capacity: 60, availableRooms: 20),
      ];
      List<Floor> floors6 = [
        Floor(floorNumber: 0, wings: wingsFloorsa1),
        Floor(floorNumber: 1, wings: wingsFloorsa2),
        Floor(floorNumber: 2, wings: wingsFloorsa3),

      ];

      Hostel hostel6 = Hostel(
          hostelName: 'Satpura',
          floors: floors6,
          wardenId: 'admin123',
          imgSrc: 'assets/images/satpura.jpg',
          occupancy : 'doubleSharing'
      );
      await hostelBox.put('Shivalik', hostel);
      await hostelBox.put('Sahyadri', hostel1);
      await hostelBox.put('Karavali', hostel2);
      await hostelBox.put('Trishul', hostel3);
      await hostelBox.put('Aravali', hostel4);
      await hostelBox.put('Vindhya', hostel5);
      await hostelBox.put('Satpura', hostel6);




      print('Hostel data stored!');

    } else {
      print('Hostel data already exists.');
    }

  }
  Future<void> addHostelData(String hostelName, Hostel hostel) async {
    if (hostelBox.containsKey(hostelName)) {
      print('Hostel data with this key already exists.');
    } else {
      await hostelBox.put(hostelName, hostel);
      print('Hostel data added for key: $hostelName');
    }
  }

  // Method to delete hostel data from the database
  Future<void> deleteHostelData(String hostelName) async {
    if (hostelBox.containsKey(hostelName)) {
      await hostelBox.delete(hostelName);
      print('Hostel data deleted for key: $hostelName');
    } else {
      print('Hostel data with key $hostelName does not exist.');
    }
  }
  Future<Hostel?> getHostelData(String hostelName) async {
    if (hostelBox.containsKey(hostelName)) {
      Hostel? hostel = hostelBox.get(hostelName);
      print('Hostel data retrieved for key: $hostelName');
      return hostel;
    } else {
      print('Hostel data with key $hostelName does not exist.');
      return null;
    }
  }
  Future<List<Hostel>> getAllHostels() async {
    List<Hostel> hostels = hostelBox.values.toList().cast<Hostel>();
    print('Retrieved ${hostels.length} hostels from the database.');
    return hostels;
  }
  Future<void> printAllHostels() async {
    final hostels = hostelBox.values.toList();
    for (var hostel in hostels) {
      print('Hostel Name: ${hostel.hostelName}, Warden ID: ${hostel.wardenId}, Image: ${hostel.imgSrc}');
      for (var floor in hostel.floors) {
        print('  Floor Number: ${floor.floorNumber}');
        for (var wing in floor.wings) {
          print('    Wing Name: ${wing.wingName}, Capacity: ${wing.capacity}, Available Rooms: ${wing.availableRooms}');
        }
      }
    }
  }



}


