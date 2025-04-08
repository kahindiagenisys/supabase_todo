import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/build_context_extensions.dart';
import 'package:my_todo/core/widgets/text_field/text_field_widget.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.isSearch,
    required this.searchFocus,
    required this.searchController,
    required this.onTap,
  });

  final bool isSearch;
  final FocusNode searchFocus;
  final TextEditingController searchController;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isSearch)
            TextFieldWidget(
              focusNode: searchFocus,
              suffix: IconButton(
                onPressed: () {
                  searchController.clear();
      
                  onTap();
                },
                icon: Icon(
                  Icons.close,
                  color: context.colorScheme.error,
                ),
              ),
              isFlex: 1,
              controller: searchController,
              hintText: "Search...",
            ),
          if (!isSearch)
            IconButton(
              onPressed: () {
                searchFocus.requestFocus();
                onTap();
              },
              icon: Icon(
                Icons.search,
              ),
            ),
        ],
      ),
    );
  }
}
