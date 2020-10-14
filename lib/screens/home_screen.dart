import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madero_reservas/custom_widgets/custom_drawer.dart';
import 'package:madero_reservas/tabs/booking_tab.dart';
import 'package:madero_reservas/tabs/home_tab.dart';
import 'package:madero_reservas/tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    //Top em modo fullscreen
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    BookingTab myBookingsTab = BookingTab();

    HomeTab homeTab = HomeTab();
    ProfileTab profileTab = ProfileTab();

    Widget _choosePage() {
      switch (_currentIndex) {
        case 0:
          return myBookingsTab;
        case 1:
          return homeTab;
        default:
          return profileTab;
      }
    }

    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          toolbarHeight: 70,
          title: Image.asset(
            'assets/images/brand/brand.png',
            fit: BoxFit.cover,
            height: 40,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFD9611E),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: CircleBottomNavigation(
          textColor: Colors.black,
          hasElevationShadows: true,
          barBackgroundColor: Color(0xFFD9611E),
          activeIconColor: Colors.white,
          inactiveIconColor: Colors.black,
          circleColor: Colors.black,
          initialSelection: _currentIndex,
          tabs: [
            TabData(
                icon: Icons.list,
                title: 'Reservas',
                fontSize: 15,
                fontWeight: FontWeight.bold),
            TabData(
                icon: Icons.home,
                title: 'Início',
                fontSize: 15,
                fontWeight: FontWeight.bold),
            TabData(
                icon: Icons.person,
                title: 'Perfíl',
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ],
          onTabChangedListener: (index) =>
              setState(() => _currentIndex = index),
        ),
        body: _choosePage());
  }
}
