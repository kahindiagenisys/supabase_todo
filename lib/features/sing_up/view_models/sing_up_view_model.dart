import 'package:flutter/cupertino.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/repositories/sing_up/sing_up_repo.dart';

class SingUpViewModel with ChangeNotifier {
  final _singUpRepo = locator<SingUpRepo>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future createUser({
    required String email,
    required String password,
    required Function(String message) onError,
    required Function(String message) onSuccess,
  }) async {
    try {
      if (_isLoading == true) return;
      isLoading = true;
      final res = await _singUpRepo.createUser(
        email: email,
        password: password,
      );

      if (res.user != null) {
        onSuccess("User sing up successfully");
      } else {
        onError("Failed to create user");
      }
    } catch (error) {
      onError(error.toString());
    } finally {
      isLoading = false;
    }
  }
}
