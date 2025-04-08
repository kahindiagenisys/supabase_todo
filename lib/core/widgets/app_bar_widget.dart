import 'package:my_todo/core/extensions/build_context_extensions.dart';
import 'package:my_todo/core/widgets/text_field/text_field_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({
    this.isCenterTitle = false,
    this.searchController,
    this.searchBarFocusNode,
    this.leadingWidth = 56,
    this.searchBar = false,
    this.titleWidget,
    this.leading,
    this.actions,
    this.bottom,
    this.title,
    super.key,
    this.alignment = Alignment.center,
  });

  final String? title;
  final Widget? leading;
  final bool isCenterTitle;
  final Widget? titleWidget;
  final double leadingWidth;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool searchBar;
  final FocusNode? searchBarFocusNode;
  final TextEditingController? searchController;
  final AlignmentGeometry alignment;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => bottom == null
      ? const Size.fromHeight(kToolbarHeight)
      : const Size.fromHeight(kToolbarHeight * 1.5);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool isSearchbarTextFiledVisibility = false;

  void handleSearchFieldToggle() async {
    if (isSearchbarTextFiledVisibility) {
      widget.searchController?.clear();
    }

    isSearchbarTextFiledVisibility = !isSearchbarTextFiledVisibility;

    widget.searchBarFocusNode?.requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context).top;

    return Container(
      color: context.colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _appBar(context, safePadding / 1.3),
          ),
          if (widget.bottom != null)
            SizedBox(
              height: widget.preferredSize.height / 2.2,
              child: widget.bottom,
            ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context, double safePadding) {
    return Container(
      color: context.colorScheme.primary,
      height: widget.preferredSize.height + safePadding,
      child: Padding(
        padding: EdgeInsets.only(top: safePadding),
        child: NavigationToolbar(
          middleSpacing: NavigationToolbar.kMiddleSpacing,
          centerMiddle: widget.isCenterTitle,
          leading: _buildLeading(context),
          middle: _buildTitle(context),
          trailing: _buildActions(context),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext ctx) {
    final isBackAvailable = ctx.canPop;
    Widget? appLeadingWidget = widget.leading;

    if (appLeadingWidget == null && isBackAvailable) {
      return BackButton(
        color: ctx.colorScheme.surface,
      );
    }

    if (widget.leading != null) {
      return ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: widget.leadingWidth),
        child: widget.leading,
      );
    }
    return const SizedBox();
  }

  Widget _buildTitle(BuildContext ctx) {
    if (isSearchbarTextFiledVisibility) {
      return SizedBox(
        height: 42,
        child: TextFieldWidget(
          outSidePadding: 0,
          focusNode: widget.searchBarFocusNode,
          controller: widget.searchController,
          fillColor: ctx.colorScheme.surfaceDim.withValues(alpha: 0.2),
          hintText: "Search",
          hintStyle: TextStyle(
            color: ctx.colorScheme.onPrimary.withValues(alpha: 0.5),
          ),
          textStyle: TextStyle(color: ctx.colorScheme.onPrimary),
          maxLine: 1,
        ),
      );
    }

    if (widget.title != null && widget.titleWidget == null) {
      final isBackAvailable = ctx.canPop;
      final isActionNull = widget.actions == null && !widget.searchBar;
      return Padding(
        padding: EdgeInsets.only(
          right: (isActionNull && isBackAvailable) ? 50 : 0,
        ),
        child: Align(
            alignment: widget.alignment,
            child: Text(
              widget.title!,
              style: boldTextStyle(size: 18, color: ctx.colorScheme.surface),
            )),
      );
    }

    if (widget.title == null && widget.titleWidget != null) {
      final isBackAvailable = ctx.canPop;
      final isActionNull = widget.actions == null && !widget.searchBar;

      return Padding(
        padding: EdgeInsets.only(
          right: (isActionNull && isBackAvailable) ? 50 : 0,
        ),
        child: widget.titleWidget!,
      );
    }

    return const SizedBox();
  }

  Widget _buildActions(BuildContext ctx) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...?widget.actions,
        if (widget.searchBar) ...[
          _buildSearchBarButton(ctx),
        ]
      ],
    );
  }

  Widget _buildSearchBarButton(BuildContext ctx) {
    return IconButton(
      onPressed: handleSearchFieldToggle,
      icon: Icon(
        isSearchbarTextFiledVisibility ? Icons.close : Icons.search,
        color: isSearchbarTextFiledVisibility
            ? ctx.colorScheme.error
            : ctx.colorScheme.onPrimary,
      ),
    );
  }
}
