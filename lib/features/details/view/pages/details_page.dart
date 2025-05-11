import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';
import 'package:roshetta/features/appointment/view/pages/appointment_page.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

final EasyDatePickerController _controller = EasyDatePickerController();
var focusDate = DateTime.now();
var today = DateTime.now();
DateTime date = DateTime(today.year, today.month, today.day);
bool isSelected = false;

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return InternetConnectionChecker(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('أختيار الميعاد'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
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
                  ),
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                Text(
                  'أختيار اليوم',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    color: Colors.deepPurple,
                  ),
                ),
                EasyDateTimeLinePicker(
                  headerOptions: const HeaderOptions(headerType: HeaderType.none),
                  controller: _controller,
                  focusedDate: focusDate,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2030, 12, 31),
                  onDateChange: (selectedDate) {
                    if (selectedDate.isBefore(date)) {
                    } else {
                      setState(() {
                        focusDate = selectedDate;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 30.0.h,
                ),
                Text(
                  'أختيار الوقت',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200.h,
                    child: GridView.builder(
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 1.50,
                      ),
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.grey
                                : Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                width: 1,
                                color: isSelected ? Colors.black : Colors.white54,
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isSelected = !isSelected;
                            });
                          },
                          child: Text(
                            '9:00 AM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppointmentPage(),
                        ));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                        style: TextStyle(
                          fontSize: 15.0.sp,
                        ),
                        'أختيار الموعد'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
