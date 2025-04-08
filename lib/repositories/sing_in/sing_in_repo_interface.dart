import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SingInRepoInterface {


  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });
}
