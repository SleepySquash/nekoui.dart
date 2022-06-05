import 'package:get/get.dart';

import '../disposable_service.dart';
import '/domain/repository/neko.dart';
import '/domain/model/neko.dart';

/// Service responsible for [Neko]'s state management.
class NekoService extends DisposableService {
  NekoService(this._nekoRepository);

  final AbstractNekoRepository _nekoRepository;

  Rx<Neko?> get neko => _nekoRepository.neko;
}
