import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  final String photo;
  final String details;
  final String name;
  final Widget child;

  const CustomCard({
    super.key,
    required this.photo,
    required this.details,
    required this.name,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    photo,
                  ),
                  backgroundColor: Colors.transparent,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      details,
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            child,
          ],
        ),
      ),
    );
  }
}
