import 'package:flutter/cupertino.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/models/auth_info.dart';
import 'package:my_todo/repositories/sing_in/sing_in_repo.dart';
import 'package:my_todo/services/secure_storage/secure_storage.dart';
import 'package:my_todo/services/token/token_service.dart';
import 'package:my_todo/state/global_state_store.dart';

class SingInViewModel with ChangeNotifier {
  final _storage = locator<SecureStorageService>();
  final _token = locator<TokenService>();
  final _singInRepo = locator<SingInRepo>();

  bool _isLoadingLogin = false;

  set isLoadingLogin(bool isLoadingLogin) {
    _isLoadingLogin = isLoadingLogin;
    notifyListeners();
  }

  bool get isLoadingLogin => _isLoadingLogin;

  Future<void> login({
    required String email,
    required String password,
    Function(String message)? onSuccess,
    Function(String message)? onError,
  }) async {
    try {
      if (isLoadingLogin) return;
      isLoadingLogin = true;

      final res = await _singInRepo.signIn(email: email, password: password);
      if (res.user == null) {
        onError?.call("Login failed");
        return;
      }
      locator<GlobalStateStore>().initCurrentUser(
        AuthInfo(
          id: res.user!.id,
          email: res.user!.email,
          token: res.session!.accessToken,
          password: password,
        ),
      );
      onSuccess?.call("Logged in successfully");
    } catch (error) {
      onError?.call(error.toString());
    } finally {
      isLoadingLogin = false;
    }
  }

  Future<AuthInfo?> getLastLoginUser() async {
    return await _storage.getLastAuthenticatedUser();
  }

  bool get isTokenExpired {
    return _token.isTokenExpired();
  }

  void logout() {
    //clear data
    _storage.clearAllLocalData();
    clearToken();
  }

  void clearToken() {
    //clear data
    _token.updateToken(null);
    _token.updateRemoveAuth(true);
  }
}
