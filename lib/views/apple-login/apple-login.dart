import 'package:collabflow/services/auth-service.dart';
import 'package:collabflow/services/secure-storage-service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:collabflow/constants/app_colors.dart';
import 'package:collabflow/l10n/app_localizations.dart';

class AppleLoginButton extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onSkip;

  const AppleLoginButton({
    super.key,
    this.onSuccess,
    this.onSkip,
  });

  @override
  State<AppleLoginButton> createState() => _AppleLoginButtonState();
}

class _AppleLoginButtonState extends State<AppleLoginButton> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final secureStorageService = Provider.of<SecureStorageService>(context, listen: false);
    final isAuthenticated = await secureStorageService.isAuthenticated();
    if (mounted) {
      setState(() {
        _isLoggedIn = isAuthenticated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final secureStorageService = Provider.of<SecureStorageService>(context, listen: false);

    // If already logged in, show logged-in state
    if (_isLoggedIn) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryPink.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primaryPink.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.primaryPink,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)?.loggedInWithApple ?? "Logged in with Apple",
              style: TextStyle(
                color: AppColors.primaryPink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return SignInWithAppleButton(
      onPressed: () async {
        final tokenResponse = await authService.signInWithApple();
        if (tokenResponse?.accessToken != null && tokenResponse?.refreshToken != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Eingeloggt ✅")),
          );
          await secureStorageService.storeAccessToken(tokenResponse!.accessToken);
          await secureStorageService.storeRefreshToken(tokenResponse.refreshToken);
          setState(() {
            _isLoggedIn = true;
          });
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login fehlgeschlagen ❌")),
          );
        }
      },
    );
  }
}
