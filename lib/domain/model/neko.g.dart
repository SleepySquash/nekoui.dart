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
      maxHunger: fields[1] as int,
      thirst: fields[2] as RxInt?,
      maxThirst: fields[3] as int,
      cleanness: fields[4] as RxInt?,
      maxCleanness: fields[5] as int,
      energy: fields[6] as RxInt?,
      maxEnergy: fields[7] as int,
      social: fields[8] as RxInt?,
      maxSocial: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Necessities obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.hunger)
      ..writeByte(1)
      ..write(obj.maxHunger)
      ..writeByte(2)
      ..write(obj.thirst)
      ..writeByte(3)
      ..write(obj.maxThirst)
      ..writeByte(4)
      ..write(obj.cleanness)
      ..writeByte(5)
      ..write(obj.maxCleanness)
      ..writeByte(6)
      ..write(obj.energy)
      ..writeByte(7)
      ..write(obj.maxEnergy)
      ..writeByte(8)
      ..write(obj.social)
      ..writeByte(9)
      ..write(obj.maxSocial);
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
