// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trait.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TraitAdapter extends TypeAdapter<Trait> {
  @override
  final int typeId = 21;

  @override
  Trait read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trait(
      fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Trait obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TraitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
