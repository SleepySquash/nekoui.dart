import 'package:hive/hive.dart';

/// Helper for implementing a "new-type" idiom.
class NewType<T> {
  const NewType(this.val);

  /// Actual value wrapped by this [NewType].
  @HiveField(0)
  final T val;

  @override
  int get hashCode => val.hashCode;

  @override
  String toString() => val.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewType<T> &&
          runtimeType == other.runtimeType &&
          val == other.val;
}

/// Adds comparison operators to [Comparable] [NewType]s.
extension NewTypeComparable<T extends Comparable> on NewType<T> {
  bool operator >(NewType<T>? other) =>
      other == null || val.compareTo(other.val) > 0;

  bool operator >=(NewType<T>? other) =>
      other == null || val.compareTo(other.val) >= 0;

  bool operator <(NewType<T>? other) =>
      other != null && val.compareTo(other.val) < 0;

  bool operator <=(NewType<T>? other) =>
      other != null && val.compareTo(other.val) <= 0;
}
