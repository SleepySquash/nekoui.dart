import 'package:nekoui/domain/service/neko.dart';

import '../disposable_service.dart';

class ProgressService extends DisposableService {
  ProgressService(this._nekoService);

  late final List<ProgressCondition> conditions;

  final NekoService _nekoService;

  @override
  void onInit() {
    conditions = [];
    super.onInit();
  }
}

class ProgressCondition {}
