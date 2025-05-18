import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roshetta/core/helper/bottom_navigator.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';
import 'package:roshetta/core/widgets/custom_card.dart';
import 'package:roshetta/features/details/view/pages/details_page.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final user = FirebaseAuth.instance.currentUser!;
List<Map<String, dynamic>> allData = [];
List<Map<String, dynamic>> searchList = [];
TextEditingController searchController = TextEditingController();
int selectedIndex = 4;
Future getUser() async {
  await FirebaseFirestore.instance.collection("doctors").get().then((value) {
    allData = value.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
    if (selectedIndex == 4 && searchController.text.isEmpty) {
      searchList = allData.toList();
    }
  });
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    getUser();
    return InternetConnectionChecker(
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('doctors').get(),
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
                  title: Text(
                    'روشتة',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: SearchBar(
                            controller: searchController,
                            hintText: 'Search',
                            leading: const CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            onChanged: (value) {
                              final input = value.toLowerCase().trim();
                              setState(() {
                                searchList = input.isEmpty
                                    ? List.from(allData)
                                    : allData.where((doc) {
                                        return (doc['name'] as String)
                                            .toLowerCase()
                                            .contains(input);
                                      }).toList();
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0.h,
                      ),
                      ToggleSwitch(
                        minWidth: 90.0,
                        cornerRadius: 20.0,
                        activeBgColors: const [
                          [Colors.deepPurpleAccent],
                          [Colors.deepPurpleAccent],
                          [Colors.deepPurpleAccent],
                          [Colors.deepPurpleAccent],
                          [Colors.deepPurpleAccent],
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: selectedIndex,
                        totalSwitches: 5,
                        labels: const [
                          'أسنان',
                          'باطنه',
                          'قلب',
                          'العيون',
                          'الكل'
                        ],
                        radiusStyle: true,
                        onToggle: (index) {
                          if (index == 4) {
                            setState(() {
                              selectedIndex = 4;
                              searchList.clear();
                              searchList = allData.toList();
                            });
                          }
                          if (index == 3) {
                            setState(() {
                              selectedIndex = 3;
                              searchList.clear();
                              searchList = allData
                                  .where((doc) => doc['specialty'] == 'عيون')
                                  .toList();
                            });
                          }
                          if (index == 2) {
                            setState(() {
                              selectedIndex = 2;
                              searchList.clear();
                              searchList = allData
                                  .where((doc) => doc['specialty'] == 'قلب')
                                  .toList();
                            });
                          }
                          if (index == 1) {
                            setState(() {
                              selectedIndex = 1;
                              searchList.clear();
                              searchList = allData
                                  .where((doc) => doc['specialty'] == 'باطنه')
                                  .toList();
                            });
                          }
                          if (index == 0) {
                            setState(() {
                              selectedIndex = 0;
                              searchList.clear();
                              searchList = allData
                                  .where((doc) => doc['specialty'] == 'اسنان')
                                  .toList();
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.0.h,
                      ),
                      SizedBox(
                        height: 450.h,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchList.length,
                          itemBuilder: (BuildContext context, int index) {
                            debugPrint(
                                '-----------------------------${searchList[index]}');
                            final data = searchList[index];

                            final id = data['id'];

                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                          docId: id,
                                          photo: data['photoUrl'],
                                          name: data['name'],
                                          details: data['details'],
                                          workDays: data['workDays'],
                                          specialty: data['specialty'],
                                        ),
                                      ));
                                },
                                child: CustomCard(
                                  photo: data['photoUrl'],
                                  details: data['details'],
                                  name: data['name'],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: data['workDays'],
                                              ),
                                              const WidgetSpan(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
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
                                                text: data['specialty'],
                                              ),
                                              WidgetSpan(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
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
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: const BottomNavigator(
                  index: 0,
                ),
              ),
            );
          }),
    );
  }
}
