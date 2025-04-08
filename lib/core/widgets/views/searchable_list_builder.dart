import 'package:flutter/material.dart';

class SearchableListView<T> extends StatelessWidget {
  const SearchableListView({
    super.key,
    required this.items,
    required this.filterFunction,
    required this.builder,
    required this.searchController,
  });

  final List<T> items;
  final TextEditingController searchController;
  final Widget Function(List<T> filteredData) builder;
  final bool Function(T data, String filterValue) filterFunction;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: searchController,
      builder: (context, value, child) {
        final filteredData = _filterData(filterValue: value.text);
        return builder(filteredData);
      },
    );
  }

  List<T> _filterData({
    required String filterValue,
  }) {
    if (filterValue.isEmpty) return items;
    return items.where((T data) => filterFunction(data, filterValue.toLowerCase())).toList();
  }
}
