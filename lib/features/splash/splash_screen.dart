import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/build_context_extensions.dart';
import 'package:my_todo/features/sing_in/view_models/sing_in_view_model.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/resources/constants/constant_messages.dart';
import 'package:my_todo/route/app_route.dart';
import 'package:my_todo/state/global_state_store.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:typethis/typethis.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final animationSpeed = 200;
  final _singIn = locator<SingInViewModel>();
  final _state = locator<GlobalStateStore>();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    final duration = applicationName.length * animationSpeed;

    Timer(
      Duration(milliseconds: duration),
      () async => await handleAppStart(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Scaffold(
      backgroundColor: color.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task,
            size: 100,
            color: color.onPrimary,
          ),
          20.height,
          Center(
            child: TypeThis(
              textAlign: TextAlign.center,
              string: applicationName,
              speed: animationSpeed,
              showBlinkingCursor: false,
              style: context.textTheme.headlineSmall?.copyWith(
                color: color.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleAppStart() async {
    final auth = await _singIn.getLastLoginUser();
log("auth === ${auth}");
    if (auth == null) {
      // No user → Navigate to Login
      launchLoginScreen();
    } else {
      _state.initCurrentUser(auth);
      final isTokenExpired = _singIn.isTokenExpired;

      if (isTokenExpired) {
        launchLoginScreen();
      } else {
        launchHomeScreen();
      }
    }
  }

  void launchLoginScreen() {
    _singIn.clearToken();
    if (context.mounted) {
      finish(context);
      context.router.replace(const SingInRoute());
    }
  }

  void launchHomeScreen() {
    if (context.mounted) {
      finish(context);
      context.router.replace(HomeRoute());
    }
  }
}
