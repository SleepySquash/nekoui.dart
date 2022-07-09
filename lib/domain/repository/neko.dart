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

import '/domain/model/neko.dart';

abstract class AbstractNekoRepository {
  static const double hungerInSecond = 100 / (5 * 60 * 60);
  static const double thirstInSecond = 100 / (2.5 * 60 * 60);
  static const double socialInSecond = 100 / (4 * 60 * 60);
  static const double toiletInLiter = 100 / (10 * 60 * 60);
  static const double energyInSecond = 100 / (16 * 60 * 60);
  static const double dirtyInSecond = 100 / (24 * 60 * 60);

  Rx<Neko> get neko;

  void eat(int value);

  void drink(int value);

  void necessity({
    double? hunger,
    double? thirst,
    double? toilet,
    double? cleanness,
    double? energy,
    double? social,
  });

  void affinity(int amount);
}
