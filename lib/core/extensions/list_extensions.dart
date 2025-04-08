extension ListExtention on List? {
  bool get isEmptyOrNull => this == null || (this != null && this!.isEmpty);
}
