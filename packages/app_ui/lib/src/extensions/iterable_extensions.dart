extension IterableExtensions<E> on Iterable<E> {
  Iterable<T> mapIndex<T>(T Function(E element, int index) convert) sync* {
    var index = 0;
    for (final element in this) {
      yield convert(element, index);
      index++;
    }
  }
}
