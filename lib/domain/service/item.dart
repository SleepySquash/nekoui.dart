import '../disposable_service.dart';
import '/domain/model/item.dart';
import '/domain/repository/item.dart';
import '/util/obs/obs.dart';

/// Service responsible for [Item]s state management.
class ItemService extends DisposableService {
  ItemService(this._itemRepository);

  final AbstractItemRepository _itemRepository;

  RxObsMap<String, Item> get items => _itemRepository.items;

  void add(Item item) => _itemRepository.add(item);

  void remove(Item item) => _itemRepository.remove(item);
}
