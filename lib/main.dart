import 'package:flutter/material.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/resources/constants/constant_messages.dart';
import 'package:my_todo/resources/theme/app_theme.dart';
import 'package:my_todo/route/app_route.dart';
import 'package:nb_utils/nb_utils.dart';

Future<void> main() async {
  await initialized();
  await setUp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final brightness = context.platformBrightness();

    bool isLightBrightness = brightness == Brightness.light;
    return MaterialApp.router(
      title: applicationName,
      theme: isLightBrightness ? AppTheme.light : AppTheme.dark,
      routerConfig: appRouter.config(),
    );
  }
}
