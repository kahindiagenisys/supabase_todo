extension MapExtensions on Map? {
  bool isValidOrNotEmpty(String key) {
    return this != null && this!.containsKey(key) && this![key].isNotEmpty;
  }
}
