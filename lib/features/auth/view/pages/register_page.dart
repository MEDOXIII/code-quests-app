import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';
import 'package:roshetta/core/widgets/custom_button.dart';
import 'package:roshetta/features/auth/view/pages/login_page.dart';
import 'package:roshetta/features/home/view/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

bool showPassword = true;
bool showConfirmPassword = true;
final emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
final formRegisterGlobalKey = GlobalKey<FormState>();

class _RegisterPageState extends State<RegisterPage> {
  Future createUser() async {
    final isValid = formRegisterGlobalKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint('++++++++++++++++++++++++++++++++++++++++++++++++++++++$e');
    }
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectionChecker(
      body: SafeArea(
        child: Scaffold(
          body: Form(
            key: formRegisterGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid Email'
                            : null,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'الايميل',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    obscureText: showPassword,
                    controller: passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) =>
                        password != null && password.length < 7
                            ? 'Enter min of 7 characters'
                            : null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'كلمة المرور',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => showPassword = !showPassword),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    obscureText: showConfirmPassword,
                    controller: confirmPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (confirmPassword) =>
                        confirmPassword != passwordController.text
                            ? 'Password Is Not Match'
                            : null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'تأكيد كلمة المرور',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(showConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => showConfirmPassword = !showConfirmPassword),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                CustomButton(
                  lable: 'إنشاء حساب',
                  onClick: () {
                    createUser();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  },
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: Text(
                        'تسجيل الدخول',
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
                      ' لديك حساب بالفعل ؟؟',
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
}
