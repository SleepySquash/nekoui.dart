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
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Neko obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
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
