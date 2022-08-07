// Copyright © 2022 NIKITA ISAENKO, <https://github.com/SleepySquash>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

import 'package:get/get.dart';

import '/domain/model/item.dart';
import '/domain/repository/item.dart';
import '/util/obs/obs.dart';

/// Service responsible for [Item]s state management.
class ItemService extends DisposableInterface {
  ItemService(this._itemRepository);

  final AbstractItemRepository _itemRepository;

  RxObsMap<String, Item> get items => _itemRepository.items;

  void add(Item item) => _itemRepository.add(item);

  /// Removes the provided [item] in the specified [count] from the [items].
  ///
  /// Fully removes the [item], if [count] is `null`.
  void remove(Item item, [int? count]) => _itemRepository.remove(item, count);
}
