import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late Timer timer;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _route(context);
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 150), // Replace with your logo
            const SizedBox(height: 20),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Loading indicator
          ],
        ),
      ),
    );
  }
}

Future<void> _route(BuildContext context) async {
  Future.delayed(const Duration(seconds: 2), () async {
    // final user = await _firebaseAuth.currentUser;
    final token = await _getToken();

    // final user = await _firebaseAuth.currentUser;
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/home'); // Adjust the route name as needed
    } else {
      Navigator.pushReplacementNamed(context, '/signIn'); // Adjust the route name as needed
    }
  });
}

Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token_key'); // Adjust token key if needed
}
