import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '/domain/model_type_id.dart';

class RxAdapter<T> extends TypeAdapter<Rx<T>> {
  @override
  final typeId = ModelTypeId.rx;

  @override
  Rx<T> read(BinaryReader reader) => Rx<T>(reader.read());

  @override
  void write(BinaryWriter writer, Rx<T> obj) => writer.write(obj.value);
}

class RxIntAdapter extends TypeAdapter<RxInt> {
  @override
  final typeId = ModelTypeId.rxInt;

  @override
  RxInt read(BinaryReader reader) => RxInt(reader.read());

  @override
  void write(BinaryWriter writer, RxInt obj) => writer.write(obj.value);
}

class RxnIntAdapter extends TypeAdapter<RxnInt> {
  @override
  final typeId = ModelTypeId.rxnInt;

  @override
  RxnInt read(BinaryReader reader) => RxnInt(reader.read());

  @override
  void write(BinaryWriter writer, RxnInt obj) => writer.write(obj.value);
}

class RxDoubleAdapter extends TypeAdapter<RxDouble> {
  @override
  final typeId = ModelTypeId.rxDouble;

  @override
  RxDouble read(BinaryReader reader) => RxDouble(reader.read());

  @override
  void write(BinaryWriter writer, RxDouble obj) => writer.write(obj.value);
}

class RxnDoubleAdapter extends TypeAdapter<RxnDouble> {
  @override
  final typeId = ModelTypeId.rxnDouble;

  @override
  RxnDouble read(BinaryReader reader) => RxnDouble(reader.read());

  @override
  void write(BinaryWriter writer, RxnDouble obj) => writer.write(obj.value);
}

class RxBoolAdapter extends TypeAdapter<RxBool> {
  @override
  final typeId = ModelTypeId.rxBool;

  @override
  RxBool read(BinaryReader reader) => RxBool(reader.read());

  @override
  void write(BinaryWriter writer, RxBool obj) => writer.write(obj.value);
}

class RxnBoolAdapter extends TypeAdapter<RxnBool> {
  @override
  final typeId = ModelTypeId.rxnBool;

  @override
  RxnBool read(BinaryReader reader) => RxnBool(reader.read());

  @override
  void write(BinaryWriter writer, RxnBool obj) => writer.write(obj.value);
}

class RxStringAdapter extends TypeAdapter<RxString> {
  @override
  final typeId = ModelTypeId.rxString;

  @override
  RxString read(BinaryReader reader) => RxString(reader.read());

  @override
  void write(BinaryWriter writer, RxString obj) => writer.write(obj.value);
}

class RxnStringAdapter extends TypeAdapter<RxnString> {
  @override
  final typeId = ModelTypeId.rxnString;

  @override
  RxnString read(BinaryReader reader) => RxnString(reader.read());

  @override
  void write(BinaryWriter writer, RxnString obj) => writer.write(obj.value);
}
