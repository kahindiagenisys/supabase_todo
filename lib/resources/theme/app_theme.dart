import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const appFlexSchemeColor = FlexScheme.brandBlue;

  static const _onPrimaryColor = SchemeColor.onPrimary;

  static const _subThemesData = FlexSubThemesData(
    blendOnColors: true,
    cardElevation: 0,
    inputDecoratorUnfocusedHasBorder: false,
    inputDecoratorFocusedHasBorder: false,
    fabAlwaysCircular: true,
    fabUseShape: true,
    fabSchemeColor: SchemeColor.primaryContainer,
    cardRadius: 10,
    bottomAppBarHeight: 60,
    tabBarDividerColor: Colors.transparent,
    tabBarIndicatorTopRadius: 8,
    tabBarIndicatorWeight: 3.5,
    tabBarUnselectedItemOpacity: 0.5,
    tabBarItemSchemeColor: _onPrimaryColor,
    tabBarIndicatorSchemeColor: _onPrimaryColor,
    tabBarIndicatorSize: TabBarIndicatorSize.label,
    tabBarUnselectedItemSchemeColor: _onPrimaryColor,
  );

  static final _fontFamily = GoogleFonts.lato().fontFamily;

  static final light = FlexThemeData.light(
    scheme: appFlexSchemeColor,
    fontFamily: _fontFamily,
    subThemesData: _subThemesData,
    keyColors: const FlexKeyColors(),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );

  static final dark = FlexThemeData.dark(
    keyColors: const FlexKeyColors(),
    scheme: appFlexSchemeColor,
    fontFamily: _fontFamily,
    subThemesData: _subThemesData,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );
}
