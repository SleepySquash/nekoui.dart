/// Type ID's of all [Hive] models just to keep them in one place.
///
/// They should not change with time to not break on already stored data by
/// previous versions of application. Add new entries to the end.
class ModelTypeId {
  static const credentials = 0;
  static const neko = 1;
  static const necessities = 2;
  static const item = 3;
  static const rx = 4;
  static const rxInt = 5;
  static const rxnInt = 6;
  static const rxDouble = 7;
  static const rxnDouble = 8;
  static const rxBool = 9;
  static const rxnBool = 10;
  static const rxString = 11;
  static const rxnString = 12;
  static const mbti = 13;
  static const skill = 14;
  static const trait = 15;
  static const mood = 16;
  static const thought = 17;
  static const dream = 18;
  static const hiveNeko = 19;
  static const hiveFlag = 20;
}
