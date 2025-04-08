import 'package:my_todo/locator.dart';
import 'package:my_todo/models/auth_info.dart';
import 'package:my_todo/repositories/sing_in/sing_in_repo_interface.dart';
import 'package:my_todo/services/secure_storage/secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SingInRepo implements SingInRepoInterface {
  final _supabaseClient = Supabase.instance.client;
  final _storage = locator<SecureStorageService>();

  @override
  Future<AuthResponse> signIn(
      {required String email, required String password}) async {
    try {
      final res = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        await _storage.setAuthenticatedUser(
          AuthInfo(
            id: res.user!.id,
            email: email,
            password: password,
            token: res.session!.accessToken,
          ),
        );

        return res;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      rethrow;
    }
  }
}
