import 'package:flutter/material.dart';
import 'package:ureeka_hackathon/screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;

  void _handleSignIn() async {
    if (_isSigningIn) return; // ❌ avoid multiple sign-ins
    setState(() => _isSigningIn = true);

    try {
      // Replace this with your actual Google Sign-In logic
      // final user = await GoogleSignInService.signInWithGoogle();

      // TEMP: Simulate a delay
      await Future.delayed(Duration(seconds: 2));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print("Sign in failed: $e");
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome! Please Log In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _handleSignIn,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  child: Center(
                    child: _isSigningIn
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Log In with Google',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


