// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/ui/screen/events_screen.dart';
import 'package:meeting/ui/screen/home_screen.dart';
import 'package:meeting/ui/screen/persons_screen.dart';
import 'package:meeting/utils/fade_indexed_stack.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    EventsScreen(),
    // Container(),
    // DashboardScreen(),
    HomeScreen(),
    UsersScreen(),
  ];
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      // body: IndexedStack(
      //   index: _selectedIndex,
      //   children: [..._screens],
      // ),
      body: FadeIndexedStack(
        index: _selectedIndex,
        key: null,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        // padding: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _selectedIndex,
            iconSize: 28,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: AppColor.primary,
            unselectedItemColor: AppColor.divider,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/ic_event.svg',
                  height: 28,
                  color:
                      _selectedIndex == 0 ? AppColor.primary : AppColor.divider,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/ic_home.svg',
                  height: 28,
                  color:
                      _selectedIndex == 1 ? AppColor.primary : AppColor.divider,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/ic_person.svg',
                  height: 28,
                  color:
                      _selectedIndex == 2 ? AppColor.primary : AppColor.divider,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
