import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/build_context_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String message;
  final double? height;
  final bool isLoading;
  final Color? loadingColor;
  final TextStyle? textStyle;

  const NoDataFoundWidget({
    super.key,
    this.message = "Data not found!",
    this.height,
    this.isLoading = false,
    this.loadingColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? context.deviceSize.height / 1.6,
      child: Center(
        child: isLoading
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor ?? context.colorScheme.primary),
        )
            : Text(
          message,
          style: textStyle ?? secondaryTextStyle(),
        ),
      ),
    );
  }
}
