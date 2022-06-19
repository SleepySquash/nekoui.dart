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
      mbti: fields[6] as MBTI?,
      traits: (fields[7] as Map?)?.cast<String, Trait>(),
    );
  }

  @override
  void write(BinaryWriter writer, Neko obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.affinity)
      ..writeByte(6)
      ..write(obj.mbti)
      ..writeByte(7)
      ..write(obj.traits);
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
