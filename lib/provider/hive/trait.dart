import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/trait.dart';
import 'base.dart';

/// [Hive] storage for the [Trait]s.
class TraitHiveProvider extends HiveBaseProvider<Trait> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'trait';

  /// Returns a list of [Trait]s from the [Hive].
  Iterable<Trait> get traits => valuesSafe;

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(TraitAdapter());
  }

  /// Puts the provided [Trait] to the [Hive].
  Future<void> put(Trait trait) => putSafe(trait.trait, trait);

  /// Returns the stored [Trait] from the [Hive].
  Trait? get(Trait trait) => getSafe(trait.trait);

  /// Removes the stored [Trait] from the [Hive].
  Future<void> remove(Traits trait) => deleteSafe(trait.index);
}
