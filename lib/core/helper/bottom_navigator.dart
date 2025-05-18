import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:roshetta/features/appointment/view/pages/appointment_page.dart';
import 'package:roshetta/features/home/view/pages/home_page.dart';
import 'package:roshetta/features/settings/view/pages/settings_page.dart';

class BottomNavigator extends StatelessWidget {
  final int index;
  const BottomNavigator({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GNav(
        rippleColor: Colors.grey, // tab button ripple color when pressed
        hoverColor: Colors.grey, // tab button hover color
        haptic: true, // haptic feedback
        tabBorderRadius: 15,
        tabActiveBorder:
            Border.all(color: Colors.black, width: 1), // tab button border
        tabBorder:
            Border.all(color: Colors.grey, width: 1), // tab button border
        tabShadow: const [
          BoxShadow(color: Colors.white54, blurRadius: 8)
        ], // tab button shadow
        curve: Curves.easeOutExpo, // tab animation curves
        duration: const Duration(milliseconds: 200), // tab animation duration
        gap: 5, // the tab button gap between icon and text
        color: Colors.grey, // unselected icon color
        activeColor: Colors.white, // selected icon and text color
        iconSize: 24, // tab button icon size
        tabBackgroundColor: Colors.deepPurple, // selected tab background color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        selectedIndex: index, // navigation bar padding
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'الرئيسيه',
          ),
          GButton(
            icon: Icons.bookmark,
            text: 'الحجز',
          ),
          GButton(
            icon: Icons.settings,
            text: 'الاعدادات',
          ),
        ],
        onTabChange: (value) {
          if (value == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          }
          if (value == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppointmentPage(),
                ));
          }
          if (value == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ));
          }
        });
  }
}
