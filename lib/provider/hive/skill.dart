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
import '/domain/model/skill.dart';
import 'base.dart';

/// [Hive] storage for the [Skill]s.
class SkillHiveProvider extends HiveBaseProvider<Skill> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'skill';

  /// Returns a list of [Skill]s from the [Hive].
  Iterable<Skill> get skills => valuesSafe;

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(SkillAdapter());
  }

  /// Puts the provided [Skill] to the [Hive].
  Future<void> put(Skill skill) => putSafe(skill.name, skill);

  /// Returns the stored [Skill] from the [Hive].
  Skill? get(String name) => getSafe(name);

  /// Removes the stored [Item] from the [Hive].
  Future<void> remove(String id) => deleteSafe(id);
}

class SkillAdapter extends TypeAdapter<Skill> {
  @override
  final typeId = ModelTypeId.skill;

  @override
  Skill read(BinaryReader reader) {
    final name = reader.read() as String;
    final value = reader.read() as int;
    final skills = (reader.read() as Map?)?.cast<String, Skill>();
    return Skill(name, value: value, skills: skills);
  }

  @override
  void write(BinaryWriter writer, Skill obj) {
    writer.write(obj.name);
    writer.write(obj.value.value);
    writer.write(obj.skills);
  }
}
