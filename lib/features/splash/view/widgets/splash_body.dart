import 'package:flutter/material.dart';
import 'package:roshetta/features/auth/view/pages/login_page.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

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
          builder: (context) => const LoginPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/icons/logo.png'),
        ),
      ),
    );
  }
}
