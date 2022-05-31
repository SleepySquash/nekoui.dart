import 'package:hive_flutter/adapters.dart';

import '../../domain/model/credentials.dart';
import 'base.dart';

// TODO: Encrypt stored data.
/// [Hive] storage for a [Credentials].
class SessionHiveProvider extends HiveBaseProvider<Credentials> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch(key: 0);

  @override
  String get boxName => 'session';

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(CredentialsAdapter());
  }

  /// Returns the stored [Credentials] from the [Hive].
  Credentials? getCredentials() => getSafe(0);

  /// Stores the provided [Credentials] to the [Hive].
  Future<void> setCredentials(Credentials credentials) =>
      putSafe(0, credentials);
}
