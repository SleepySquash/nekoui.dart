import 'package:hive_flutter/hive_flutter.dart';

import '/domain/repository/flag.dart';
import 'base.dart';

/// [Hive] storage for the [Neko].
class FlagHiveProvider extends HiveBaseProvider<bool> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'flag';

  @override
  void registerAdapters() {}

  /// Puts the provided [HiveNeko] to the [Hive].
  Future<void> put(Flags flag, bool value) => putSafe(flag.index, value);

  /// Returns the stored [HiveNeko] from the [Hive].
  bool? get(Flags flag) => getSafe(flag.index);

  /// Removes the store [HiveNeko] from the [Hive].
  Future<void> remove(Flags flag) => deleteSafe(flag.index);
}
