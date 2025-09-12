import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import 'package:collabflow/constants/api_config.dart';

class AuthService {

  Future<TokenResponse?> signInWithApple() async {
    try {
      // Check if Apple Sign-In is available
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        print("Apple Sign-In ist nicht verfügbar auf diesem Gerät");
        throw PlatformException(
          code: "NOT_AVAILABLE",
          message: "Apple Sign-In ist nicht verfügbar auf diesem Gerät",
        );
      }

      // 1. Apple Login starten
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null) {
        throw PlatformException(
          code: "NO_TOKEN",
          message: "Kein IdentityToken von Apple erhalten",
        );
      }
      final backendUrl = "${await ApiConfig.baseUrl}/auth/apple"; 

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "IdentityToken": identityToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data["tokenResponse"]["accessToken"] as String;
        final refreshToken = data["tokenResponse"]["refreshToken"] as String;
        final userId = data["tokenResponse"]["userId"] as String;
        return TokenResponse(accessToken: accessToken, refreshToken: refreshToken, userId: userId);
      } else {
        throw Exception("Backend-Fehler: ${response.body}");
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      print("Apple Sign-In Authorization Fehler: ${e.code} - ${e.message}");
      return null;
    } on PlatformException catch (e) {
      print("Platform Fehler: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("Unerwarteter Apple Sign-In Fehler: $e");
      return null;
    }
  }
}

class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;

  TokenResponse({required this.accessToken, required this.refreshToken, required this.userId});
}
