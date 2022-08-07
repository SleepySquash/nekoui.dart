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
  static const race = 21;
  static const applicationSettings = 22;
}
