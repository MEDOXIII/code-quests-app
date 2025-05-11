import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roshetta/core/helper/internet_connection_checker.dart';
import 'package:roshetta/features/details/view/pages/details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final user = FirebaseAuth.instance.currentUser!;
List<Map<String, dynamic>> allData = [];
Future getUser() async {
  await FirebaseFirestore.instance.collection("doctors").get().then((value) {
    debugPrint(
        '-----------------------------**************************${value.docs}');
    allData = value.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  });
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    getUser();
    return InternetConnectionChecker(
      body: FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('doctors')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No doctors found'));
        }

        final docs = snapshot.data!.docs;
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
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SearchBar(
                        hintText: 'Search',
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                  ),
                                  'أسنان',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                  ),
                                  'باطنه',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                  ),
                                  'قلب',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                  ),
                                  'العيون',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                    color: Colors.white,
                                  ),
                                  'الكل',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    SizedBox(
                      height: 500.h,
                      child: ListView.builder(
                        
                        // shrinkWrap: true,
                        itemCount: allData.length,
                        itemBuilder: (BuildContext context, int index) {
                           final data = docs[index].data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DetailsPage(),
                                    ));
                              },
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundImage: ExactAssetImage(
                                              data['photoUrl'],
                                            ),
                                          ),
                                          Text(
                                            data['name '],
                                            style: TextStyle(fontSize: 15.sp),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0.h,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data['details'],
                                              style: TextStyle(fontSize: 15.sp),
                                            ),
                                            Text(
                                              data['specialty '],
                                              style: TextStyle(fontSize: 15.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0.h,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                             data['workDays'],
                                              style: TextStyle(fontSize: 15.sp),
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
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'الرئيسيه',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark),
                    label: 'الحجز',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'الاعدادات',
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
