import 'package:flutter/material.dart';
import 'package:my_todo/models/auth_info.dart';

class GlobalStateStore with ChangeNotifier {
  AuthInfo? _currentUser;

  AuthInfo? get currentUser => _currentUser;

  void initCurrentUser(AuthInfo auth) {
    _currentUser = auth;
  }
}
