import 'package:agency_app/Screens/add_funds_bottomsheet.dart';
import 'package:agency_app/Screens/profile_screen.dart';
import 'package:agency_app/Screens/send_money_screen.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:agency_app/widgets/home_tiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_client_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _obscureBalance = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            // padding: EdgeInsets.all(20),
            child: Column(children: [
      Container(
          height: size.height * 0.35,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0146, 0.9879],
              colors: [
                Color(0xFF00080F),
                Color(0xFF00284A),
              ],
              transform: GradientRotation(136.62 * (3.1415926 / 180.0)),
            ),
          ),
          child: Column(children: [
            SizedBox(height: 50),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ProfileScreen()));

                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Hello there,',
                    style: bodyTextWhite,
                  ),
                  Text(
                    "Username",
                    style: subHeading,
                  )
                ]),
              ]),
              Row(children: [
                TextButton(
                  onPressed: () {},
                  child: Text("USD"),
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xff00284A),
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                ),
                IconButton(
                  icon: Icon(
                    _obscureBalance ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureBalance = !_obscureBalance;
                    });
                  },
                )
              ])
            ]),

            // ACOUNT BALANCE AREA

            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Account Balance",
                style: bodyTextWhite,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "USD 100,000",
                style: mainHeading,
              ),
              SizedBox(
                height: 10,
              ),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Commission",
                  style: bodyTextWhite,
                ),
                TextSpan(
                  text: " 100,000",
                  style: bodyTextWhite,
                )
              ]))
            ])
          ])),

      Column(children: [
        Container(
          height: size.height * 0.13,
          width: size.width * 1,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SendMoneyScreen()));
                },
                  child: HomeTile(tileName: "Send Money", iconTile: Icons.send_outlined))),
              Expanded(child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return AddFundsBottomSheet(
                        wallet: '100',
                      );
                    },
                  );
                },
                  child: HomeTile(tileName: "Fund Wallet", iconTile: Icons.account_balance_wallet))),
              Expanded(child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddClientScreen()));
                },
                  child: HomeTile(tileName: "Add Client", iconTile: Icons.person_add_alt_1))),
            ],
          ),

        ),
        GestureDetector(
          onTap: () {
            //TODO: navigate to the APprovals
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: size.height * 0.06,
            width: size.width * 1,
            child: Row(


              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "2",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                    ),
                  ),
                ),

                SizedBox(width: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Approvals", style: bodyTextBlackBigger,),
                    Text("Click to view details", style: bodyTextBlack,),
                  ]

                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios),
              ]
            )
          ),
        ),

        Divider(color: Colors.grey,  thickness: 1,),
        Container(

            child: Text("Transactions", style: bodyTextBlackBigger,textAlign: TextAlign.start,)),
        Container(
          height: size.height * 0.7,
          width: size.width * 1,


          child: ListView.builder(
              padding: EdgeInsets.zero,
              // itemCount: ,
              itemBuilder: (context, index) {
            return ListTile(
              leading: Stack(
                children:[
                  CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),

              ]
              ),
              title: Text("Transaction Name", style: bodyTextBlackBigger,),
              subtitle: Text("Date and time", style: bodyTextBlack,),
              trailing: Text("USD 100,000", style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700,),),

            );
          }),
        )




      ])
    ])));
  }
}
