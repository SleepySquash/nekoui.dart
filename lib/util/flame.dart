import 'package:flame/components.dart';

extension Vector2ToNormalizedExtension on Vector2 {
  Vector2 height(double height) {
    return Vector2(height * x / y, height);
  }
}
