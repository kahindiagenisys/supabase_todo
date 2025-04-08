import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_todo/core/extensions/string_extensions.dart';
import 'package:my_todo/models/auth_info.dart';

/// user data save of using this key (id,email,token)
const lastAuthenticatedUserKey = "lastAuthenticatedUser";

class SecureStorageService {
  final storage = const FlutterSecureStorage();

  /// Deletes all stored data from secure storage
  Future<void> clearAllLocalData() async {
    await storage.deleteAll();
  }

/// Stores authenticated user information securely
/// [user] - The user information (AuthInfo) to be stored
/// If the user is `null`, the function does nothing
Future<AuthInfo?> setAuthenticatedUser(AuthInfo? user) async {
  if (user == null) return user;
  await storage.write(
    key: lastAuthenticatedUserKey,
    value: jsonEncode(user),
  );
  return user;
}

/// Retrieves the last authenticated user information
/// Returns `null` if no data is found
Future<AuthInfo?> getLastAuthenticatedUser() async {
  String? userDetail = await storage.read(
    key: lastAuthenticatedUserKey,
  );
  if (userDetail.isValueEmptyOrNull) {
    return null;
  }
  return AuthInfo.fromJson(json.decode(userDetail!));
}
}
