import 'package:flutter/material.dart';
import 'package:my_todo/core/widgets/no_data_found_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class PaginationWidget<T> extends StatelessWidget {
  const PaginationWidget({
    super.key,
    required this.listData,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.childWidget,
    required this.onReset,
    this.loadingIndicator,
    this.noDataMessage = "No Data Available",
  });

  final List<T> listData;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final VoidCallback onReset;
  final Widget Function(T data) childWidget;

  final Widget? loadingIndicator;
  final String noDataMessage;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        final bool isMaxScroll = _isAtMaxScroll(scrollInfo.metrics);
        if (!isLoadingMore && isMaxScroll) {
          onLoadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          onReset();
          onLoadMore();
        },
        child: ListView.builder(
          itemCount: listData.length + (isLoadingMore ? 1 : 0), // Fix: Correct itemCount calculation
          itemBuilder: (context, index) {
            if (listData.isEmpty) {
              return NoDataFoundWidget(
                message: noDataMessage,
                isLoading: isLoadingMore,
              );
            }

            // Fix: Ensure we access only valid indices
            if (index >= listData.length) {
              return loadingIndicator ??
                  const Center(child: CircularProgressIndicator()).paddingAll(16);
            }

            return childWidget(listData[index]);
          },
        ),
      ),
    );
  }

  bool _isAtMaxScroll(ScrollMetrics metrics) {
    return metrics.pixels >= metrics.maxScrollExtent;
  }
}
