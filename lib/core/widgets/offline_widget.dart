import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfflineWidget extends StatefulWidget {
  const OfflineWidget({super.key});

  @override
  State<OfflineWidget> createState() => _OfflineWidgetState();
}

class _OfflineWidgetState extends State<OfflineWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/No connection-bro.png',
                fit: BoxFit.contain,
              ),
              Text(
                'لا يوجد اتصال بالانترنت ',
                style: TextStyle(
                  fontSize: 20.sp
                ),
              ),
              Text(
                'برجاء التحقق من اتصال الانترنت الخاص بك',
                style: TextStyle(
                  fontSize: 15.sp
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
