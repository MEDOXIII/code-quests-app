import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';
import 'package:roshetta/core/helper/show_snack_bar.dart';
import 'package:roshetta/core/widgets/custom_button.dart';
import 'package:roshetta/core/widgets/side_title.dart';
import 'package:roshetta/features/appointment/view/pages/appointment_page.dart';

class DetailsPage extends StatefulWidget {
  final String docId;
  final String photo;
  final String name;
  final String details;
  final String workDays;
  final String specialty;
  const DetailsPage({
    super.key,
    required this.docId,
    required this.photo,
    required this.name,
    required this.details,
    required this.workDays,
    required this.specialty,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

final EasyDatePickerController _controller = EasyDatePickerController();
var focusDate = DateTime.now();
var today = DateTime.now();
DateTime date = DateTime(today.year, today.month, today.day);
int indexSelected = 0;
List<Map<String, dynamic>> allData = [];
bool isWorkDay = false;
final List<MapEntry<String, bool>> hoursList = [];
bool isTimeSelected = false;
final user = FirebaseAuth.instance.currentUser!.uid;
String todayStr = '';
String hourLabel = '';
String selectedTime = '';

class _DetailsPageState extends State<DetailsPage> {
  Future getDays() async {
    await FirebaseFirestore.instance
        .collection("doctors")
        .doc(widget.docId)
        .collection('availableDays')
        .get()
        .then((value) {
      // debugPrint('----------------------------*${value.docs}');

      allData = value.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    });
  }

  Future setAppointment({
    required String userId,
    required String doctorId,
    required String photo,
    required String name,
    required String details,
    required String time,
    required String date,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('appointments').doc().set({
        'userId': userId,
        'doctorId': doctorId,
        'photoUrl': photo,
        'name': name,
        'details': details,
        'date': date,
        'time': time,
      });

      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.docId)
          .collection('availableDays')
          .doc(date)
          .update({
        '$time': false,
      });
    } catch (e) {
      debugPrint('++++++++++++++++++++++++++++++++$e');
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AppointmentPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    getDays();
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  widget.photo,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.name,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    widget.details,
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: widget.workDays,
                                      ),
                                      const WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Icon(
                                            Icons.timer_outlined,
                                            color: Colors.deepPurple,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: widget.specialty,
                                      ),
                                      WidgetSpan(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Image.asset(
                                            'assets/icons/price-tag.png',
                                            width: 10.w,
                                            height: 10.h,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                const SideTitle(
                  title: 'أختيار اليوم',
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                EasyDateTimeLinePicker(
                  headerOptions:
                      const HeaderOptions(headerType: HeaderType.none),
                  controller: _controller,
                  focusedDate: focusDate,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2030, 12, 31),
                  onDateChange: (selectedDate) {
                    if (selectedDate.isBefore(date)) {
                    } else {
                      setState(() {
                        focusDate = selectedDate;
                        isWorkDay = false;
                        isTimeSelected = false;

                        todayStr =
                            DateFormat('dd-MM-yyyy').format(selectedDate);
                        // debugPrint('**************************$allData');
                        final isDay =
                            allData.any((dayMap) => dayMap['id'] == todayStr);

                        if (isDay) {
                          final Map<String, dynamic> dayMap =
                              allData.firstWhere((m) => m['id'] == todayStr);
                          // debugPrint('**************************$dayMap');
                          isWorkDay = true;
                          hoursList.clear();
                          dayMap.forEach((key, value) {
                            if (key != 'id' && value is bool) {
                              hoursList.add(MapEntry(key, value));
                            }
                          });
                        }
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 30.0.h,
                ),
                const SideTitle(
                  title: 'أختيار الوقت',
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                isWorkDay
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100.h,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10),
                            physics: const ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childAspectRatio: 1.50,
                            ),
                            itemCount: hoursList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final bool isSelected = index == indexSelected;
                              final entry = hoursList[index];
                              hourLabel = entry.key;
                              final isAvailable = entry.value;

                              return isAvailable
                                  ? TextButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isSelected
                                            ? Colors.deepPurpleAccent
                                            : Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(
                                            width: 1,
                                            color: isSelected
                                                ? Colors.black
                                                : Colors.white54,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedTime = entry.key;
                                          debugPrint(
                                              '**************************$selectedTime');

                                          indexSelected = index;
                                          isTimeSelected = true;
                                        });
                                      },
                                      child: Text(
                                        hourLabel,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                            width: 1,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        hourLabel,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 100.h,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'لا يوجد مواعيد اليوم',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                CustomButton(
                  lable: 'أختيار الموعد',
                  onClick: isTimeSelected
                      ? () {
                          debugPrint('**************************$selectedTime');
                          setAppointment(
                            userId: user,
                            doctorId: widget.docId,
                            photo: widget.photo,
                            name: widget.name,
                            details: widget.details,
                            time: selectedTime,
                            date: todayStr,
                          );
                        }
                      : () {
                          showSnackBar(context, 'يرجى إختيار موعد ');
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
