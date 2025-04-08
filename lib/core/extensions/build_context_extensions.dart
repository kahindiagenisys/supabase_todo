import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

extension BuildContextExtensions on BuildContext {

  void popOrNavigateBack<T extends Object?>({T? result}) {
    if (router.canPop()) {
      router.maybePop(result);
    } else {
      router.back();
    }
  }

  ThemeData get _theme => Theme.of(this);

  ColorScheme get colorScheme => _theme.colorScheme;

  Size get deviceSize => MediaQuery.sizeOf(this);

  void closeKeyBord() {
    if (isKeyboardShowing) return;
    FocusScope.of(this).requestFocus(
      FocusNode(),
    );
    return;
  }
}
