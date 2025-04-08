import 'package:my_todo/repositories/sing_up/sing_up_repo_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SingUpRepo implements SingUpRepoInterface {
  final _supabaseClient = Supabase.instance.client;

  @override
  Future<AuthResponse> createUser(
      {required String email, required String password}) async {
    try {
      final res =
          await _supabaseClient.auth.signUp(password: password, email: email,);

      return res;
    } catch (e) {
      rethrow;
    }
  }
}
