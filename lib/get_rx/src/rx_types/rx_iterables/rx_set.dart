part of rx_types;

class RxSet<E> extends SetMixin<E>
    with NotifyManager<Set<E>>, RxObjectMixin<Set<E>>
    implements RxInterface<Set<E>> {
  RxSet([Set<E> initial = const {}]) {
    if (initial != null) {
      _value = Set.from(initial);
    }
  }

  /// Adds [item] only if [condition] resolves to true.
  void addIf(dynamic condition, E item) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) add(item);
  }

  /// Adds all [items] only if [condition] resolves to true.
  void addAllIf(dynamic condition, Iterable<E> items) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(items);
  }

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  RxSet<E> operator +(Set<E> val) {
    addAll(val);
    refresh();
    return this;
  }

  /// Adds only if [item] is not null.
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  /// Adds only if [item] is not null.
  void addAllNonNull(Iterable<E> item) {
    if (item != null) addAll(item);
  }

  /// Replaces all existing items of this list with [item]
  void assign(E item) {
    _value ??= <E>{};
    clear();
    add(item);
  }

  void update(void fn(Iterable<E> value)) {
    fn(value);
    refresh();
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(Iterable<E> items) {
    _value ??= <E>{};
    clear();
    addAll(items);
  }

  @override
  @protected
  Set<E> get value {
    if (RxInterface.proxy != null) {
      RxInterface.proxy.addListener(subject);
    }
    return _value;
  }

  @override
  @protected
  set value(Set<E> val) {
    if (_value == val) return;
    _value = val;
    refresh();
  }

  @override
  bool add(E value) {
    final val = _value.add(value);
    refresh();
    return val;
  }

  @override
  bool contains(Object element) {
    return value.contains(element);
  }

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  int get length => value.length;

  @override
  E lookup(Object object) {
    return value.lookup(object);
  }

  @override
  bool remove(Object item) {
    var hasRemoved = _value.remove(item);
    if (hasRemoved) {
      refresh();
    }
    return hasRemoved;
  }

  @override
  Set<E> toSet() {
    return value.toSet();
  }

  @override
  void addAll(Iterable<E> item) {
    _value.addAll(item);
    refresh();
  }

  @override
  void clear() {
    _value.clear();
    refresh();
  }

  @override
  void removeAll(Iterable<Object> elements) {
    _value.removeAll(elements);
    refresh();
  }

  @override
  void retainAll(Iterable<Object> elements) {
    _value.retainAll(elements);
    refresh();
  }

  @override
  void retainWhere(bool Function(E) E) {
    _value.retainWhere(E);
    refresh();
  }
}

extension SetExtension<E> on Set<E> {
  RxSet<E> get obs {
    if (this != null) {
      return RxSet<E>(<E>{})..addAllNonNull(this);
    } else {
      return RxSet<E>(null);
    }
  }
}
