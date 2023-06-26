
import 'package:agency_app/Screens/profile_screen.dart';
import 'package:agency_app/Screens/send_money_screen.dart';
import 'package:agency_app/Screens/transactions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'account_screen.dart';
import 'home_screen.dart';


class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentIndex = 0;

  final screens = [
    const HomeScreen(),
     SendMoneyScreen(),
    const ProfileScreen(),



  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],



        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Color(0xff00284A),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize:11,

          onTap: (index) => setState(()=>  currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.square), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.square), label: 'Transactions'),
            BottomNavigationBarItem(icon: Icon(Icons.square), label: 'Account'),
             ],
        )
    );
  }


}
