import 'package:get/get.dart';

import '../disposable_service.dart';
import '/domain/repository/neko.dart';
import '/domain/model/item.dart';
import '/domain/model/neko.dart';

/// Service responsible for [Neko]'s state management.
class NekoService extends DisposableService {
  NekoService(this._nekoRepository);

  final AbstractNekoRepository _nekoRepository;

  Rx<Neko?> get neko => _nekoRepository.neko;

  bool consume(Consumable item) {
    bool consumed = false;
    if (neko.value != null) {
      if (item is Eatable) {
        if (neko.value!.necessities.hunger.value + item.hunger / 3 <=
            neko.value!.necessities.maxHunger) {
          _nekoRepository.eat(item.hunger);
          consumed = true;
        }
      }

      if (item is Drinkable) {
        if (neko.value!.necessities.thirst.value + item.thirst / 3 <=
            neko.value!.necessities.maxThirst) {
          _nekoRepository.drink(item.thirst);
          consumed = true;
        }
      }
    }

    return consumed;
  }
}
