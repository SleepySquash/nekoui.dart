import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'list.dart';

/// `GetX`-reactive [ObsList].
///
/// Behaves like a wrapper around [List] with its [changes] exposed.
class RxObsList<E> extends ListMixin<E>
    with NotifyManager<ObsList<E>>, RxObjectMixin<ObsList<E>>
    implements RxInterface<ObsList<E>> {
  /// Creates a new list with the provided [initial] values.
  RxObsList([List<E> initial = const []]) : _value = ObsList.from(initial);

  /// Creates a new list of the given length with the provided [fill] element at
  /// each position.
  factory RxObsList.filled(int length, E fill, {bool growable = false}) =>
      RxObsList(List.filled(length, fill, growable: growable));

  /// Creates an empty list.
  factory RxObsList.empty({bool growable = false}) =>
      RxObsList(List.empty(growable: growable));

  /// Creates a new list containing all the provided [elements].
  factory RxObsList.from(Iterable elements, {bool growable = true}) =>
      RxObsList(List.from(elements, growable: growable));

  /// Creates a list from the provided [elements].
  factory RxObsList.of(Iterable<E> elements, {bool growable = true}) =>
      RxObsList(List.of(elements, growable: growable));

  /// Generates a list of values.
  factory RxObsList.generate(int length, E Function(int index) generator,
          {bool growable = true}) =>
      RxObsList(List.generate(length, generator, growable: growable));

  /// Creates an unmodifiable list containing all the provided [elements].
  factory RxObsList.unmodifiable(Iterable elements) =>
      RxObsList(List.unmodifiable(elements));

  /// Internal actual value of the [ObsList] this [RxObsMap] holds.
  late ObsList<E> _value;

  @override
  Iterator<E> get iterator => value.iterator;

  /// Returns stream of record of changes of this [RxObsList].
  Stream<ListChangeNotification<E>> get changes => _value.changes;

  /// Emits a new [event].
  ///
  /// May be used to explicitly notify the listeners of the [changes].
  void emit(ListChangeNotification<E> event) {
    _value.emit(event);
    refresh();
  }

  @override
  void operator []=(int index, E val) {
    _value[index] = val;
    refresh();
  }

  @override
  RxObsList<E> operator +(Iterable<E> other) {
    addAll(other);
    refresh();
    return this;
  }

  @override
  E operator [](int index) {
    return value[index];
  }

  @override
  void add(E element) {
    _value.add(element);
    refresh();
  }

  @override
  void addAll(Iterable<E> iterable) {
    _value.addAll(iterable);
    refresh();
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _value.removeWhere(test);
    refresh();
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _value.retainWhere(test);
    refresh();
  }

  @override
  int get length => value.length;

  @override
  @protected
  ObsList<E> get value {
    RxInterface.proxy?.addListener(subject);
    return _value;
  }

  @override
  set length(int newLength) {
    _value.length = newLength;
    refresh();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _value.insertAll(index, iterable);
    refresh();
  }

  @override
  Iterable<E> get reversed => value.reversed;

  @override
  Iterable<E> where(bool Function(E) test) {
    return value.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return value.whereType<T>();
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    _value.sort(compare);
    refresh();
  }
}
