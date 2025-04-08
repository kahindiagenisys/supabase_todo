import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class KeyboardDismissOnBack extends StatelessWidget {
  const KeyboardDismissOnBack({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: !context.isKeyboardShowing,
        onPopInvokedWithResult: (didPop, result) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: child);
  }
}
