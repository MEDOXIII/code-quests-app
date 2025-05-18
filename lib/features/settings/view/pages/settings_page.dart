import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roshetta/core/helper/bottom_navigator.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';
import 'package:roshetta/features/auth/view/pages/login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InternetConnectionChecker(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('الاعدادات'),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.wallet),
                        title: Text(
                          'المدفوعات (قريبا)',
                          style: TextStyle(
                            fontSize: 20.0.sp,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_circle_right,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.exit_to_app,
                        ),
                        title: Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            fontSize: 20.0.sp,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_circle_right,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavigator(
            index: 2,
          ),
        ),
      ),
    );
  }
}
