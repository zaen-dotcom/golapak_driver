import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import '../theme/colors.dart';
import '../components/alertdialog.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _showCustomAlert(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => CustomAlert(
            title: title,
            message: message,
            confirmText: 'OK',
            onConfirm: () => Navigator.of(context).pop(),
          ),
    );
  }

void _handleLogin() async {
  if (_isLoading) return;

  setState(() => _isLoading = true);

  final email = _emailController.text.trim();
  final password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    setState(() => _isLoading = false);
    _showCustomAlert("Gagal", "Email dan Password tidak boleh kosong.");
    return;
  }

  debugPrint("Memulai proses login...");
  debugPrint("Email: $email");
  debugPrint("Password: ${'*' * password.length}");

  final response = await loginKurir(email, password);

  debugPrint("Response dari login API: $response");

  setState(() => _isLoading = false);

  if (response['success'] == true) {
    final token = response['access_token'];
    debugPrint("Status sukses. Token: $token");

    if (token != null && token is String) {
      await TokenManager.saveToken(token);
      debugPrint("Token berhasil disimpan.");
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    } else {
      debugPrint("Token tidak ditemukan dalam respons.");
      _showCustomAlert("Gagal", "Token tidak ditemukan.");
    }
  } else {
    debugPrint("Login gagal: ${response['message']}");
    _showCustomAlert(
      "Login Gagal",
      response['message'] ?? "Terjadi kesalahan.",
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1F38),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 50),
                  Text(
                    "Log In Driver",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Silakan masuk ke akun Driver.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: "Email",
                    hintText: "example@gmail.com",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Password",
                    hintText: "●●●●●●●●",
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Colors.black87),
                      children: [
                        const TextSpan(
                          text: 'Ada kendala login? ',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        TextSpan(
                          text: 'Hubungi Admin',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  debugPrint('Hubungi Admin diklik');
                                },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "LOG IN",
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
