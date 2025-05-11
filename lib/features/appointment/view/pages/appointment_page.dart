import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InternetConnectionChecker(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('الحجوزات'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: ExactAssetImage(
                                'assets/icons/logo.png',
                              ),
                            ),
                            Text(
                              'دكتور / احمد محمود عطا',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '09:00 PM',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                            Text(
                              '10/05/2025',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white70,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                child: Text(
                                    style: TextStyle(
                                      fontSize: 15.0.sp,
                                      color: Colors.black54,
                                    ),
                                    'إلغاء الموعد'),
                              ),
                            ),
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                child: Text(
                                    style: TextStyle(
                                      fontSize: 15.0.sp,
                                      color: Colors.white,
                                    ),
                                    'تأجيل الموعد'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
