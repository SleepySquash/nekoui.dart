import 'package:flutter/material.dart';

/// Asset of a novel existing on a scene.
abstract class NovelObject {
  NovelObject();

  GlobalKey key = GlobalKey();

  Future<void> init() => Future.value();
  Future<void> dispose() => Future.value();
}

/// Single line of a [Scenario] representing some action.
abstract class ScenarioLine {
  const ScenarioLine();

  /// Executes this [ScenarioLine].
  Future<void> execute() => Future.value();
}

mixin WaitableMixin on ScenarioLine {
  bool get wait;
}

/// [ScenarioLine]s representing a novel's scenario.
class Scenario {
  const Scenario(this.lines);
  final List<ScenarioLine> lines;

  ScenarioLine? at(int i) {
    if (lines.length <= i) {
      return null;
    }

    return lines[i];
  }
}
