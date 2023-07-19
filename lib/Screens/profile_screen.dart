import 'package:agency_app/Screens/User%20authentication/login_screen.dart';
import 'package:agency_app/Screens/home_screen.dart';
import 'package:agency_app/Screens/navigation.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'add_funds_bottomsheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = const FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    final size =  MediaQuery.of(context).size;
    return Scaffold(

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff00284A),
          leading: IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NavPage(profileInfo: null, accessToken: null,)));
          }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        ),

        body: SingleChildScrollView(

          child: Column(

            children: [
              Container(
                height: size.height * 0.30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:  Color(0xff00284A),
                ),
                child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.withOpacity(0.5),

                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(Icons.check_circle, color: Colors.green,)

                            )
                          ]
                      ),

                      SizedBox(height: 8.0),
                      Text(
                        "John Doe", style: mainHeading,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        "Phone Number", style: subHeading,
                      ),
                    ]
                ),


              ),


              Container(
                height: size.height * 0.20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:  Colors.white,
                  boxShadow:  [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                    )
                  ]
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListTile(

                          leading: Icon(Icons.circle, color: Colors.grey,),
                          title: Text(
                            "Edit Profile", style: blueText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.circle, color: Colors.grey,),
                          title: Text(
                            "Set limits", style: blueText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return AddFundsBottomSheet(
                                  wallet: '100',
                                );
                              },
                            );
                          },
                          child: ListTile(
                            leading: Icon(Icons.circle, color: Colors.grey,),
                            title: Text(
                              "Fund Wallet", style: blueText,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {

                            await _storage.deleteAll();


                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: ListTile(
                            leading: Icon(Icons.circle, color: Colors.grey,),
                            title: Text(
                              "Log out", style: blueText,
                            ),
                          ),
                        ),
                      ),
                    ]
                )
              )




            ]
          )

        ),
    );
  }
}
