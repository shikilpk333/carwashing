import 'package:carwashbooking/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../Signup/view/signup_screen.dart';
import '../../Home/view/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/login_model.dart';
import '../repository/login_repository.dart';
import '../presenter/login_presenter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginView {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Color backgroundColor = const Color(0xFF0D111C);

  late LoginPresenter _presenter;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final model = LoginModel();
    final repository = LoginRepository(model);
    _presenter = LoginPresenter(view: this, repository: repository);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _presenter.dispose();
    super.dispose();
  }

  @override
  void showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: aquaSwatch,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void showLoading() => setState(() => _isLoading = true);

  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void navigateToHome(User user) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
    );
  }

  @override
  void navigateToSignup() {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  @override
  void clearPasswordField() => _passwordController.clear();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset('assets/animation/SecureLogin.json'),
              ),
            ),
            const Text(
              "Welcome back!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Sign in to continue",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 40),

            /// Email Field
            CustomTextField(
              label: "Email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              icon: Icons.email_outlined,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 20),

            /// Password Field
            CustomTextField(
              label: "Password",
              controller: _passwordController,
              keyboardType: TextInputType.text,
              icon: Icons.lock_outline,
              isPassword: true,
              isLoading: _isLoading,
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (_) {}),
                    const Text("Remember me",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                TextButton(
                  onPressed: () => showError('Forgot password feature coming soon'),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: aquaSwatch,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => _presenter.signIn(
                          _emailController.text,
                          _passwordController.text,
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00C8FF),
                  //Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBackgroundColor: aquaSwatch.withOpacity(0.5),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: _isLoading ? null : _presenter.goToSignup,
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: _isLoading ? Colors.grey.shade600 : Colors.grey,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: _isLoading
                              ? aquaSwatch.withOpacity(0.5)
                              : aquaSwatch,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable TextField Widget
class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData icon;
  final bool isPassword;
  final bool isLoading;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.icon,
    this.isPassword = false,
    this.isLoading = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscure : false,
          enabled: !widget.isLoading,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter your ${widget.label}",
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: Icon(widget.icon, color: Colors.grey),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: widget.isLoading
                        ? null
                        : () => setState(() => _obscure = !_obscure),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: aquaSwatch),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: widget.isLoading,
            fillColor: widget.isLoading ? Colors.grey.shade800 : null,
          ),
        ),
      ],
    );
  }
}
