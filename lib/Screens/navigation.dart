
import 'package:agency_app/Screens/profile_screen.dart';
import 'package:agency_app/Screens/send_money_screen.dart';
import 'package:agency_app/Screens/transactions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'account_screen.dart';
import 'home_screen.dart';


class NavPage extends StatefulWidget {
  final  profileInfo;
  final  accessToken;

  const NavPage({Key? key,required this.profileInfo,required this.accessToken}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentIndex = 0;
  List<Widget> screens = [];


  // final screens = [
  //    HomeScreen(profileInfo: widget.profileInfo, accessToken: widget.accessToken,),
  //    SendMoneyScreen(),
  //   const ProfileScreen(),
  //
  // ];


  @override
  void initState() {
    super.initState();
    screens = [
      HomeScreen(profileInfo: widget.profileInfo, accessToken: widget.accessToken),
      SendMoneyScreen(profileInfo: widget.profileInfo, accessToken: widget.accessToken,),
      ProfileScreen(),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          setState(() {
            currentIndex = 0;
          });
          return false; // Prevent default back button behavior
        }
        return true; // Allow default back button behavior
      },
      child: Scaffold(
          body: screens[currentIndex],



          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            selectedItemColor: Color(0xff00284A),
            unselectedItemColor: Colors.grey,
            selectedFontSize: 11,
            unselectedFontSize:11,

            onTap: (index) => setState(()=>  currentIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Transactions'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
               ],
          )
      ),
    );
  }


}
