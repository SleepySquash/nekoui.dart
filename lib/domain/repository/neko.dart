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
