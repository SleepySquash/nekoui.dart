import 'package:nekoui/domain/repository/flag.dart';
import 'package:nekoui/provider/hive/flag.dart';

class FlagRepository implements AbstractFlagRepository {
  FlagRepository(this._local);
  final FlagHiveProvider _local;

  bool? get(Flags flag) => _local.get(flag);
  Future<void> set(Flags flag, bool value) => _local.put(flag, value);
}
