import 'package:my_todo/features/home/views/home_screen.dart';
import 'package:my_todo/features/sing_in/views/sing_in_screen.dart';
import 'package:my_todo/features/sing_up/views/sing_up_screen.dart';
import 'package:my_todo/features/splash/splash_screen.dart';
import 'package:auto_route/auto_route.dart';

part 'app_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: SplashRoute.page,
        ),
        AutoRoute(
          page: SingInRoute.page,
        ),
        AutoRoute(
          page: SingUpRoute.page,
        ),
        AutoRoute(
          page: HomeRoute.page,
        ),
      ];
}
