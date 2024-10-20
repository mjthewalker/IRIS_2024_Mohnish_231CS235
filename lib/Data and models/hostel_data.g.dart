// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hostel_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WingAdapter extends TypeAdapter<Wing> {
  @override
  final int typeId = 0;

  @override
  Wing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wing(
      wingName: fields[0] as String,
      capacity: fields[1] as int,
      availableRooms: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Wing obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.wingName)
      ..writeByte(1)
      ..write(obj.capacity)
      ..writeByte(2)
      ..write(obj.availableRooms);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FloorAdapter extends TypeAdapter<Floor> {
  @override
  final int typeId = 1;

  @override
  Floor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Floor(
      floorNumber: fields[0] as int,
      wings: (fields[1] as List).cast<Wing>(),
    );
  }

  @override
  void write(BinaryWriter writer, Floor obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.floorNumber)
      ..writeByte(1)
      ..write(obj.wings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HostelAdapter extends TypeAdapter<Hostel> {
  @override
  final int typeId = 2;

  @override
  Hostel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hostel(
      hostelName: fields[0] as String,
      floors: (fields[1] as List).cast<Floor>(),
      wardenId: fields[2] as String,
      imgSrc: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Hostel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.hostelName)
      ..writeByte(1)
      ..write(obj.floors)
      ..writeByte(2)
      ..write(obj.wardenId)
      ..writeByte(3)
      ..write(obj.imgSrc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HostelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
