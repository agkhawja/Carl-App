import 'package:carl/Food_Prefrence/food_prefrence.dart';
import 'package:carl/Grocery_List/groocery.dart';
import 'package:carl/Pantry/pantry_screen.dart';
import 'package:carl/home_screens/home_screen.dart';
import 'package:carl/settings_screens/setting_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key, this.index = 0});

  final int index;

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  int _currentIndex = 0;
  List<Widget> _screens = [];

  @override
  void initState() {
    _currentIndex = widget.index;
    _screens = [
      HomeScreen(),
      PantryScreen(),
      GroceryScreen(),
      FoodPreferenceScreen(),
      SettingsScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.roboto(
          fontSize: 12.px,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontSize: 12.px,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assests/home_screen/home_icon.png",
              scale: 1,
              color: _currentIndex == 0 ? Color(0xff1F1F1F) : Color(0xffA2A2A2),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assests/home_screen/pantry.png",
              scale: 1,
              color: _currentIndex == 1 ? Color(0xff1F1F1F) : Color(0xffA2A2A2),
            ),
            label: 'Pantry',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assests/home_screen/groceries_icon.png",
                scale: 1,
                color:
                    _currentIndex == 2 ? Color(0xff1F1F1F) : Color(0xffA2A2A2)),
            label: 'Groceries',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assests/home_screen/food_pref_icon.png",
              scale: 1,
              color: _currentIndex == 3 ? Color(0xff1F1F1F) : Color(0xffA2A2A2),
            ),
            label: 'Food Pref',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assests/home_screen/settings_icon.png",
              scale: 1,
              color: _currentIndex == 3 ? Color(0xff1F1F1F) : Color(0xffA2A2A2),
            ),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
