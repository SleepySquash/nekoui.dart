// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neko.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NekoAdapter extends TypeAdapter<Neko> {
  @override
  final int typeId = 1;

  @override
  Neko read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Neko(
      name: fields[0] as RxString?,
      age: fields[1] as RxInt?,
      height: fields[2] as RxInt?,
      weight: fields[3] as RxInt?,
      necessities: fields[4] as Necessities?,
      affinity: fields[5] as RxInt?,
    );
  }

  @override
  void write(BinaryWriter writer, Neko obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.necessities)
      ..writeByte(5)
      ..write(obj.affinity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NekoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NecessitiesAdapter extends TypeAdapter<Necessities> {
  @override
  final int typeId = 2;

  @override
  Necessities read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Necessities(
      hunger: fields[0] as RxInt?,
      thirst: fields[1] as RxInt?,
      cleanness: fields[2] as RxInt?,
      sleep: fields[3] as RxInt?,
      social: fields[4] as RxInt?,
    );
  }

  @override
  void write(BinaryWriter writer, Necessities obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.hunger)
      ..writeByte(1)
      ..write(obj.thirst)
      ..writeByte(2)
      ..write(obj.cleanness)
      ..writeByte(3)
      ..write(obj.sleep)
      ..writeByte(4)
      ..write(obj.social);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NecessitiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
