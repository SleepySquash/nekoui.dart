import 'package:get/get.dart';

/// Helper for managing [Get] dependencies with a scoped lifetime.
class ScopedDependencies {
  /// List of dependencies disposing functions.
  final List<void Function()> _cleanup = [];

  /// Puts the given [dependency] in this scope.
  T put<T>(T dependency) {
    _cleanup.add(() => Get.delete<T>());
    return Get.put<T>(dependency);
  }

  /// Disposes all the scoped dependencies.
  void dispose() {
    for (var e in _cleanup) {
      e.call();
    }
    _cleanup.clear();
  }
}
