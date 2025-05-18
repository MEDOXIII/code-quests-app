import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';
import 'package:roshetta/core/helper/show_snack_bar.dart';
import 'package:roshetta/core/widgets/custom_card.dart';
import 'package:roshetta/core/widgets/side_title.dart';
import 'package:roshetta/features/appointment/view/pages/appointment_page.dart';

class ChangeAppointmentPage extends StatefulWidget {
  final String docId;
  final String photo;
  final String name;
  final String details;
  final String time;
  final String date;
  final String appointmentId;
  const ChangeAppointmentPage({
    super.key,
    required this.docId,
    required this.photo,
    required this.name,
    required this.details,
    required this.time,
    required this.date,
    required this.appointmentId,
  });

  @override
  State<ChangeAppointmentPage> createState() => _ChangeAppointmentPageState();
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

Future getDays({required String doctorId}) async {
  await FirebaseFirestore.instance
      .collection("doctors")
      .doc(doctorId)
      .collection('availableDays')
      .get()
      .then((value) {
    allData = value.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  });
}

Future changeAppointment({
  required String time,
  required String doctorId,
  required String oldTime,
  required String date,
  required String appointmentId,
  required String oldDate,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .update({
      'date': date,
      'time': time,
    });
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('availableDays')
        .doc(date)
        .update({
      '$time': false,
    });
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('availableDays')
        .doc(oldDate)
        .update({
      '$oldTime': true,
    });
  } catch (e) {
    debugPrint('++++++++++++++++++++++++++++++++$e');
  }
}

class _ChangeAppointmentPageState extends State<ChangeAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    getDays(doctorId: widget.docId);
    return InternetConnectionChecker(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('تغيير الميعاد'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomCard(
                    photo: widget.photo,
                    details: widget.details,
                    name: widget.name,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.time,
                            style: TextStyle(fontSize: 15.sp),
                          ),
                          Text(
                            widget.date,
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
                const SideTitle(
                  title: 'تغيير اليوم',
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
                  title: 'تغيير الوقت',
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
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: isTimeSelected
                      ? () {
                          debugPrint('**************************$selectedTime');
                          changeAppointment(
                            time: selectedTime,
                            doctorId: widget.docId,
                            oldTime: widget.time,
                            date: todayStr,
                            oldDate: widget.date,
                            appointmentId: widget.appointmentId,
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AppointmentPage(),
                              ));
                        }
                      : () {
                          showSnackBar(context, 'يرجى إختيار موعد ');
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                        style: TextStyle(
                          fontSize: 15.0.sp,
                          color: Colors.white,
                        ),
                        'تغيير الموعد'),
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
