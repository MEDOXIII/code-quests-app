import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelButton extends StatelessWidget {
  final String lable;
  final VoidCallback onClick;
  const CancelButton({
    super.key,
    required this.lable,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onPressed: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          style: TextStyle(
            fontSize: 15.0.sp,
            color: Colors.black54,
          ),
          lable,
        ),
      ),
    );
  }
}
