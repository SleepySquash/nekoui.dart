// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mbti.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MBTIAdapter extends TypeAdapter<MBTI> {
  @override
  final int typeId = 13;

  @override
  MBTI read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MBTI(
      ei: fields[0] as RxInt?,
      sn: fields[1] as RxInt?,
      tf: fields[2] as RxInt?,
      jp: fields[3] as RxInt?,
    );
  }

  @override
  void write(BinaryWriter writer, MBTI obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.ei)
      ..writeByte(1)
      ..write(obj.sn)
      ..writeByte(2)
      ..write(obj.tf)
      ..writeByte(3)
      ..write(obj.jp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MBTIAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
