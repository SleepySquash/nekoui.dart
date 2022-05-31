import '../disposable_service.dart';
import '/domain/repository/neko.dart';

/// Service responsible for [Neko]'s state management.
class NekoService extends DisposableService {
  NekoService(this._nekoRepository);

  final AbstractNekoRepository _nekoRepository;
}
