import 'package:jwt_decode/jwt_decode.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/services/secure_storage/secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';

class TokenService {
  TokenService._();

  static Future<TokenService> create() async {
    final service = TokenService._();
    await service._init();
    return service;
  }

  final _storage = locator<SecureStorageService>();

  Future<void> _init() async {
    final value = await _storage.getLastAuthenticatedUser();
    _token = value?.token;
  }

  String? _token;

  bool _removeAuth = false;

  String? get token => _token;

  bool get removeAuth => _removeAuth;

  void updateRemoveAuth(bool value) {
    _removeAuth = value;
  }

  Future<void> updateToken(String? token) async {
    _token = token;
    if (!token.isEmptyOrNull) {
      await configIdToken(token!);
    }
  }

  Future<void> clearStoredPasswordOrToken() async {
    final user = await _storage.getLastAuthenticatedUser();
    if (user?.email != null) {
      final updatedUser = user!.copyWith(
        email: user.email,
      );
      await _storage.setAuthenticatedUser(updatedUser);
    }
  }

  DateTime? parseTimeLimit(String timeLimit) {
    try {
      return DateTime.parse(timeLimit);
    } catch (e) {
      return null;
    }
  }

  bool isTokenExpired() {
    if (_token == null) {
      return true;
    }
    return JwtDecoder.isExpired(token!);
  }

  bool hasOwnerByToken(String? token) {
    if (token == null) return false;

    try {
      final payload = Jwt.parseJwt(token);
      final claims = payload['https://hasura.io/jwt/claims'];

      if (claims == null) return false;

      return claims['x-hasura-default-role'] == "owner";
    } catch (e) {
      log("Token parsing error: $e");
      return false;
    }
  }

  Future<void> configIdToken(String token) async {
    try {
      final payload = Jwt.parseJwt(token);
      final claims = payload['https://hasura.io/jwt/claims'];

      if (claims == null) throw Exception("JWT claims not found");




    } catch (e) {
      log("Error in configIdToken: $e");
    }
  }
}
