import 'package:flutter/material.dart';

/// Extension adding an ability to lighten a color.
extension ColorExtension on Color {
  /// Returns a lighten variant of this color.
  Color lighten([double amount = .2]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  /// Returns a darken variant of this color.
  Color darken([double amount = .2]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

extension TextExtension on Text {
  static List<Shadow> outline({
    double thickness = 1.5,
    Color color = Colors.black,
  }) {
    return [
      Shadow(
        offset: Offset(-thickness, -thickness),
        color: color,
      ),
      Shadow(
        offset: Offset(thickness, -thickness),
        color: color,
      ),
      Shadow(
        offset: Offset(thickness, thickness),
        color: color,
      ),
      Shadow(
        offset: Offset(-thickness, thickness),
        color: color,
      ),
    ];
  }
}
