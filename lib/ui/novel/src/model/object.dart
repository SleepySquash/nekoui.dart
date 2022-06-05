import 'package:mutex/mutex.dart';

import 'scenario.dart';

/// [ScenarioLine] adding the provided [object] to the scene.
class ScenarioAddLine extends ScenarioLine with WaitableMixin {
  const ScenarioAddLine(this.object, {this.wait = true});
  final NovelObject object;

  @override
  final bool wait;

  @override
  Future<void> execute() {
    return object.init();
  }
}

mixin GuardedMixin {
  final Mutex guard = Mutex();
  void unlock() {
    if (guard.isLocked) {
      guard.release();
    }
  }
}

/// Character as a [NovelObject].
class Character extends NovelObject with GuardedMixin {
  Character(
    this.asset, {
    this.duration = const Duration(milliseconds: 500),
  });

  final String asset;

  final Duration duration;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }
}

/// Background as a [NovelObject].
class Background extends NovelObject with GuardedMixin {
  Background(
    this.asset, {
    this.duration = const Duration(milliseconds: 500),
  });

  final String asset;

  final Duration duration;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }
}

/// Dialog as a [NovelObject].
class Dialogue extends NovelObject with GuardedMixin {
  Dialogue({
    this.by,
    required this.text,
  });

  final String? by;
  final String text;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }
}

class BackdropRect extends NovelObject {}
