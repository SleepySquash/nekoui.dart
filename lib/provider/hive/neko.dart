import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/neko.dart';
import 'base.dart';

/// [Hive] storage for the [Neko].
class NekoHiveProvider extends HiveBaseProvider<Neko> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'neko';

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(NekoAdapter());
  }

  /// Puts the provided [Neko] to [Hive].
  Future<void> put(Neko neko) => putSafe(0, neko);

  /// Returns the stored [Neko] from [Hive].
  Neko? get() => getSafe(0);

  /// Removes the store [Neko] from [Hive].
  Future<void> remove() => deleteSafe(0);
}
