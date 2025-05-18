import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roshetta/core/helper/bottom_navigator.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';
import 'package:roshetta/core/widgets/cancel_button.dart';
import 'package:roshetta/core/widgets/custom_button.dart';
import 'package:roshetta/core/widgets/custom_card.dart';
import 'package:roshetta/features/appointment/view/pages/change_appointment_page.dart';
import 'package:roshetta/features/home/view/pages/home_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

List<Map<String, dynamic>> allInfo = [];

List appointmentList = [];
List availableHours = [];
String dropdownvalue = 'Item 1';
int indexSelected = 0;
bool isTimeSelected = false;
var availableDays = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
final user = FirebaseAuth.instance.currentUser!.uid;

Future getAppointment() async {
  await FirebaseFirestore.instance
      .collection("appointments")
      .where('userId', isEqualTo: user)
      .get()
      .then((value) {
    allInfo = value.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
    appointmentList = allInfo.toList();
  });
}

Future deleteAppointments({
  required String appointmentId,
  required String doctorId,
  required String time,
  required String date,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .delete();
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('availableDays')
        .doc(date)
        .update({
      '$time': true,
    });
  } catch (e) {
    debugPrint('++++++++++++++++++++++++++++++++$e');
  }
}

Future getDays({
  required String doctorId,
}) async {
  await FirebaseFirestore.instance
      .collection("doctors")
      .doc(doctorId)
      .collection('availableDays')
      .get()
      .then((value) {
    final days = value.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
    debugPrint('********----------------*${days}');

    availableDays = days.map((dayMap) => dayMap['id'] as String).toList();
    debugPrint('------------*****----------------*${availableDays}');
  });
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    getAppointment();

    return InternetConnectionChecker(
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("appointments")
              .where('userId', isEqualTo: user)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Scaffold(
                  body: Center(child: Text('No doctors found')));
            }

            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text('الحجوزات'),
                ),
                body: appointmentList.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 550.h,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: appointmentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  debugPrint(
                                      '-----------------------------${appointmentList[index]}');
                                  final data = appointmentList[index];
                                  final id = data['id'];
                                  return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: CustomCard(
                                        photo: data['photoUrl'],
                                        details: data['details'],
                                        name: data['name'],
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    data['time'],
                                                    style: TextStyle(
                                                        fontSize: 15.sp),
                                                  ),
                                                  Text(
                                                    data['date'],
                                                    style: TextStyle(
                                                        fontSize: 15.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0.h,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CancelButton(
                                                    lable: 'إلغاء الموعد',
                                                    onClick: () {
                                                      deleteAppointments(
                                                        appointmentId: id,
                                                        doctorId:
                                                            data['doctorId'],
                                                        time: data['time'],
                                                        date: data['date'],
                                                      );
                                                      setState(() {});
                                                    },
                                                  ),
                                                  CustomButton(
                                                    lable: 'تأجيل الموعد',
                                                    onClick: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChangeAppointmentPage(
                                                              docId: data[
                                                                  'doctorId'],
                                                              photo: data[
                                                                  'photoUrl'],
                                                              name:
                                                                  data['name'],
                                                              details: data[
                                                                  'details'],
                                                              time:
                                                                  data['time'],
                                                              date:
                                                                  data['date'],
                                                              appointmentId: id,
                                                            ),
                                                          ));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'لا يوجد اي حجوزات',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 25.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomButton(
                            lable: 'حجز موعد',
                            onClick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ));
                            },
                          ),
                        ],
                      ),
                bottomNavigationBar: const BottomNavigator(
                  index: 1,
                ),
              ),
            );
          }),
    );
  }
}
