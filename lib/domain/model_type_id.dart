/// Type ID's of all [Hive] models just to keep them in one place.
///
/// They should not change with time to not break on already stored data by
/// previous versions of application. Add new entries to the end.
class ModelTypeId {
  static const credentials = 0;
  static const neko = 1;
  static const necessities = 2;
  static const item = 3;
  static const itemEntry = 4;
  static const cupcakeItem = 5;
  static const rx = 6;
  static const rxInt = 7;
  static const rxnInt = 8;
  static const rxDouble = 9;
  static const rxnDouble = 10;
  static const rxBool = 11;
  static const rxnBool = 12;
  static const rxString = 13;
  static const rxnString = 14;
  static const waterBottleItem = 15;
}
