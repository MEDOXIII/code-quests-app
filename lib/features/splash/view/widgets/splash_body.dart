import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roshetta/features/auth/view/pages/login_page.dart';
import 'package:roshetta/features/home/view/pages/home_page.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

bool isLogin = false;

class _SplashBodyState extends State<SplashBody> {
  @override
  void initState() {
    get();
    super.initState();
  }

  Future<void> get() async {
    await Future.delayed(const Duration(milliseconds: 900));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isLogin ? const HomePage() : const LoginPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          isLogin = true;
        } else {
          isLogin = false;
        }
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: Image.asset('assets/icons/logo.png'),
            ),
          ),
        );
      },
    );
  }
}
