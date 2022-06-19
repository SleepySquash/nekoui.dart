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
