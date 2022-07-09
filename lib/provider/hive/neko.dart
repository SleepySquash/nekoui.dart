// Copyright © 2022 NIKITA ISAENKO, <https://github.com/SleepySquash>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model_type_id.dart';
import '/domain/model/mbti.dart';
import '/domain/model/mood.dart';
import '/domain/model/necessities.dart';
import '/domain/model/neko.dart';
import '/domain/model/trait.dart';
import 'adapters.dart';
import 'base.dart';

part 'neko.g.dart';

/// [Hive] storage for the [Neko].
class NekoHiveProvider extends HiveBaseProvider<HiveNeko> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'neko';

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(HiveNekoAdapter());
    Hive.maybeRegisterAdapter(MBTIAdapter());
    Hive.maybeRegisterAdapter(MoodAdapter());
    Hive.maybeRegisterAdapter(NecessitiesAdapter());
    Hive.maybeRegisterAdapter(NekoAdapter());
    Hive.maybeRegisterAdapter(RxAdapter());
    Hive.maybeRegisterAdapter(RxDoubleAdapter());
    Hive.maybeRegisterAdapter(RxIntAdapter());
    Hive.maybeRegisterAdapter(RxStringAdapter());
    Hive.maybeRegisterAdapter(TraitAdapter());
  }

  /// Puts the provided [HiveNeko] to the [Hive].
  Future<void> put(HiveNeko neko) => putSafe(0, neko);

  /// Returns the stored [HiveNeko] from the [Hive].
  HiveNeko? get() => getSafe(0);

  /// Removes the store [HiveNeko] from the [Hive].
  Future<void> remove() => deleteSafe(0);
}

@HiveType(typeId: ModelTypeId.hiveNeko)
class HiveNeko extends HiveObject {
  HiveNeko(this.neko) : updatedAt = DateTime.now();

  @HiveField(0)
  final Neko neko;

  @HiveField(1)
  DateTime updatedAt;
}

class NekoAdapter extends TypeAdapter<Neko> {
  @override
  final int typeId = ModelTypeId.neko;

  @override
  Neko read(BinaryReader reader) {
    return Neko(
      name: reader.read() as String,
      age: reader.read() as int,
      height: reader.read() as int,
      weight: reader.read() as int,
      necessities: reader.read() as Necessities,
      affinity: reader.read() as int,
      mbti: reader.read() as MBTI,
      mood: reader.read() as Mood,
    );
  }

  @override
  void write(BinaryWriter writer, Neko obj) {
    writer
      ..write(obj.name.value)
      ..write(obj.age.value)
      ..write(obj.height.value)
      ..write(obj.weight.value)
      ..write(obj.necessities)
      ..write(obj.affinity.value)
      ..write(obj.mbti)
      ..write(obj.mood.value);
  }
}
