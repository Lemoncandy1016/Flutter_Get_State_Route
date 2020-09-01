import 'dart:async';

import 'package:flutter/foundation.dart';

import '../rx_core/rx_impl.dart';
import '../rx_core/rx_interface.dart';
import '../rx_typedefs/rx_typedefs.dart';

class RxSet<E> implements Set<E>, RxInterface<Set<E>> {
  RxSet([Set<E> initial]) {
    _list = initial;
  }

  RxSet<E> _list = Set<E>();

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  bool get isEmpty => value.isEmpty;

  bool get canUpdate {
    return _subscriptions.length > 0;
  }

  @override
  bool get isNotEmpty => value.isNotEmpty;

  StreamController<Set<E>> subject = StreamController<Set<E>>.broadcast();
  Map<Stream<Set<E>>, StreamSubscription> _subscriptions = Map();

  /// Adds [item] only if [condition] resolves to true.
  void addIf(condition, E item) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) add(item);
  }

  /// Adds all [items] only if [condition] resolves to true.
  void addAllIf(condition, Iterable<E> items) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(items);
  }

  operator []=(int index, E val) {
    _list[index] = val;
    subject.add(_list);
  }

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  RxSet<E> operator +(Iterable<E> val) {
    addAll(val);
    subject.add(_list);
    return this;
  }

  @override
  bool add(E value) {
    final val = _list.add(value);
    subject.add(_list);
    return val;
  }

  void addAll(Iterable<E> item) {
    _list.addAll(item);
    subject.add(_list);
  }

  /// Adds only if [item] is not null.
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  /// Adds only if [item] is not null.
  void addAllNonNull(Iterable<E> item) {
    if (item != null) addAll(item);
  }

  void insert(int index, E item) {
    _list.insert(index, item);
    subject.add(_list);
  }

  void insertAll(int index, Iterable<E> iterable) {
    _list.insertAll(index, iterable);
    subject.add(_list);
  }

  int get length => value.length;

  /// Removes an item from the list.
  ///
  /// This is O(N) in the number of items in the list.
  ///
  /// Returns whether the item was present in the list.
  bool remove(Object item) {
    bool hasRemoved = _list.remove(item);
    if (hasRemoved) {
      subject.add(_list);
    }
    return hasRemoved;
  }

  E removeAt(int index) {
    E item = _list.removeAt(index);
    subject.add(_list);
    return item;
  }

  E removeLast() {
    E item = _list.removeLast();
    subject.add(_list);
    return item;
  }

  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    subject.add(_list);
  }

  void removeWhere(bool Function(E) test) {
    _list.removeWhere(test);
    subject.add(_list);
  }

  void clear() {
    _list.clear();
    subject.add(_list);
  }

  void sort([int compare(E a, E b)]) {
    _list.sort();
    subject.add(_list);
  }

  close() {
    _subscriptions.forEach((observable, subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    subject.close();
  }

  /// Replaces all existing items of this list with [item]
  void assign(E item) {
    clear();
    add(item);
  }

  void update(void fn(Iterable<E> value)) {
    fn(value);
    subject.add(_list);
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(Iterable<E> items) {
    clear();
    addAll(items);
  }

  @protected
  Set<E> get value {
    if (getObs != null) {
      getObs.addListener(subject.stream);
    }
    return _list;
  }

  String get string => value.toString();

  addListener(Stream<Set<E>> rxGetx) {
    if (_subscriptions.containsKey(rxGetx)) {
      return;
    }
    _subscriptions[rxGetx] = rxGetx.listen((data) {
      subject.add(data);
    });
  }

  set value(Iterable<E> val) {
    if (_list == val) return;
    _list = val;
    subject.add(_list);
  }

  Stream<Set<E>> get stream => subject.stream;

  StreamSubscription<Set<E>> listen(void Function(Set<E>) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      stream.listen(onData, onError: onError, onDone: onDone);

  void bindStream(Stream<Iterable<E>> stream) =>
      stream.listen((va) => value = va);

  @override
  E get first => value.first;

  @override
  E get last => value.last;

  @override
  bool any(bool Function(E) test) {
    return value.any(test);
  }

  @override
  Set<R> cast<R>() {
    return value.cast<R>();
  }

  @override
  bool contains(Object element) {
    return value.contains(element);
  }

  @override
  E elementAt(int index) {
    return value.elementAt(index);
  }

  @override
  bool every(bool Function(E) test) {
    return value.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E) f) {
    return value.expand(f);
  }

  @override
  E firstWhere(bool Function(E) test, {E Function() orElse}) {
    return value.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T, E) combine) {
    return value.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return value.followedBy(other);
  }

  @override
  void forEach(void Function(E) f) {
    value.forEach(f);
  }

  @override
  String join([String separator = ""]) {
    return value.join(separator);
  }

  @override
  E lastWhere(bool Function(E) test, {E Function() orElse}) {
    return value.lastWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> map<T>(T Function(E) f) {
    return value.map(f);
  }

  @override
  E reduce(E Function(E, E) combine) {
    return value.reduce(combine);
  }

  @override
  E get single => value.single;

  @override
  E singleWhere(bool Function(E) test, {E Function() orElse}) {
    return value.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    return value.skip(count);
  }

  @override
  Iterable<E> skipWhile(bool Function(E) test) {
    return value.skipWhile(test);
  }

  @override
  Iterable<E> take(int count) {
    return value.take(count);
  }

  @override
  Iterable<E> takeWhile(bool Function(E) test) {
    return value.takeWhile(test);
  }

  @override
  List<E> toList({bool growable = true}) {
    return value.toList(growable: growable);
  }

  @override
  Set<E> toSet() {
    return value.toSet();
  }

  @override
  Iterable<E> where(bool Function(E) test) {
    return value.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return value.whereType<T>();
  }

  @override
  bool containsAll(Iterable<Object> other) {
    return value.containsAll(other);
  }

  @override
  Set<E> difference(Set<Object> other) {
    return value.difference(other);
  }

  @override
  Set<E> intersection(Set<Object> other) {
    return value.intersection(other);
  }

  @override
  E lookup(Object object) {
    return value.lookup(object);
  }

  @override
  void removeAll(Iterable<Object> elements) {
    _list.removeAll(elements);
    subject.add(_list);
  }

  @override
  void retainAll(Iterable<Object> elements) {
    _list.retainAll(elements);
    subject.add(_list);
  }

  @override
  void retainWhere(bool Function(E) E) {
    _list.retainWhere(E);
    subject.add(_list);
  }

  @override
  Set<E> union(Set<E> other) {
    return value.union(other);
  }
}

extension SetExtension<E> on Set<E> {
  RxSet<E> get obs {
    if (this != null)
      return RxSet<E>(<E>{})..addAllNonNull(this);
    else
      return RxSet<E>(null);
  }
}
