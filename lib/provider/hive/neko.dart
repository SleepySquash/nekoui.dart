import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/mbti.dart';
import '/domain/model/necessities.dart';
import '/domain/model/neko.dart';
import '/domain/model/trait.dart';
import 'adapters.dart';
import 'base.dart';

/// [Hive] storage for the [Neko].
class NekoHiveProvider extends HiveBaseProvider<Neko> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'neko';

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(MBTIAdapter());
    Hive.maybeRegisterAdapter(NecessitiesAdapter());
    Hive.maybeRegisterAdapter(NekoAdapter());
    Hive.maybeRegisterAdapter(RxAdapter());
    Hive.maybeRegisterAdapter(RxIntAdapter());
    Hive.maybeRegisterAdapter(RxStringAdapter());
    Hive.maybeRegisterAdapter(TraitAdapter());
  }

  /// Puts the provided [Neko] to the [Hive].
  Future<void> put(Neko neko) => putSafe(0, neko);

  /// Returns the stored [Neko] from the [Hive].
  Neko? get() => getSafe(0);

  /// Removes the store [Neko] from the [Hive].
  Future<void> remove() => deleteSafe(0);
}
