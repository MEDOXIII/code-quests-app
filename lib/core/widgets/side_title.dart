import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideTitle extends StatelessWidget {
  final String title;
  const SideTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0.sp,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }
}
