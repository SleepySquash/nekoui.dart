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

import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoui/domain/model_type_id.dart';

part 'thought.g.dart';

@HiveType(typeId: ModelTypeId.thought)
class Thought extends HiveObject {
  Thought(
    this.value, {
    this.left = const Duration(seconds: 5),
  });

  /// [Thought] text representation.
  @HiveField(0)
  final String value;

  /// How long until this [Thought] dissolves.
  @HiveField(1)
  Duration left;

  /// [Timer] dissolving this [Thought].
  Timer? timer;
}
