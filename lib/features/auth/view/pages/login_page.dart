import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';
import 'package:roshetta/features/auth/view/pages/register_page.dart';
import 'package:roshetta/features/home/view/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool showPassword = true;
final emailController = TextEditingController();
final passwordController = TextEditingController();
final formGlobalKey = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  Future singIn() async {
    final isValid = formGlobalKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint('*************************************$e');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectionChecker(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return SafeArea(
              child: Scaffold(
                body: Form(
                  key: formGlobalKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 200.h,
                          width: 200.w,
                          child: Image.asset('assets/icons/logo.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: TextFormField(
                            controller: emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'Enter a valid Email'
                                    : null,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Email',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: showPassword,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (password) =>
                                password != null && password.length < 5
                                    ? 'Enter min of 5 characters'
                                    : null,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'password',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () => setState(
                                    () => showPassword = !showPassword),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: singIn,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.white,
                              ),
                              'تسجيل الدخول',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ));
                              },
                              child: Text(
                                '!! إنشاء حساب',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0.w,
                            ),
                            Text(
                              'ليس لديك حساب ؟؟',
                              style: TextStyle(
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
