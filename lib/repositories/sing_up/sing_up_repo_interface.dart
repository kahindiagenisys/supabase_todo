import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SingUpRepoInterface {
  Future<AuthResponse> createUser({
    required String email,
    required String password,
  });
}
