// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'necessities.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
