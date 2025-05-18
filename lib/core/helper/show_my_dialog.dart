import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roshetta/core/widgets/custom_button.dart';

Future<void> showMyDialog({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
            child: Text(
          title,
          style: TextStyle(fontSize: 20.sp),
        )),
        content: Text(
          textAlign: TextAlign.center,
          message,
          style: TextStyle(fontSize: 20.sp),
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              lable: 'حسنا',
              onClick: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
