extension ListExt<E> on List<E> {

  E? firstWhereOrNull(bool Function(E element) test) {
    for (dynamic element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}