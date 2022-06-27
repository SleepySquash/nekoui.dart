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
