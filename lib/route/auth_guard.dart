import 'package:auto_route/auto_route.dart';

// A guard that checks if the user is authenticated before allowing navigation.
class AuthGuard extends AutoRouteGuard {
  late final _auth;

  @override

  /// This method is called before navigation to check if the user is authenticated.
  /// If the user is authenticated, it allows the navigation to proceed.
  /// Otherwise, it can redirect the user to the login route.
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    if (await _auth.isAuthValid) {
      resolver.next(true);
    } else {
      // resolver.redirect(const LoginRoute());
    }
  }
}
