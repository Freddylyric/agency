import 'dart:convert';

import 'package:agency_app/Screens/add_funds_bottomsheet.dart';
import 'package:agency_app/Screens/pending_transactions_screen.dart';
import 'package:agency_app/Screens/profile_screen.dart';
import 'package:agency_app/Screens/send_money_screen.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:agency_app/widgets/home_tiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agency_app/config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';


import 'User authentication/login_screen.dart';
import 'add_client_screen.dart';

class HomeScreen extends StatefulWidget {
  final profileInfo;
  final accessToken;

  const HomeScreen({Key? key, required this.profileInfo, required this.accessToken}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = const FlutterSecureStorage();
  bool _obscureBalance = true;
  late String? userName = '';
  late String? profileEmail = '';
  late String? profilePhone= '';
  late String? companyName = '';
  late String? availableBalance = '';
  late String? currency = '';
  late String? commission= '';
 late List<dynamic> successfulTransactions ;
  late List<dynamic> pendingTransactions ;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }



  Map<String, dynamic> decodeJWTToken(String base64EncodedToken) {
    try {
      // Step 1: Decode the Base64-encoded JWT token
      String decodedToken = utf8.decode(base64.decode(base64EncodedToken));

      // Step 2: Split the token into header, payload, and signature
      List<String> tokenParts = decodedToken.split('.');

      if (tokenParts.length == 3) {
        // Step 3: Decode the payload (second part)
        String decodedPayload = utf8.decode(base64.decode(tokenParts[1]));

        // Step 4: Parse the decoded payload as a JSON object
        Map<String, dynamic> profileData = jsonDecode(decodedPayload);

        return profileData;
      } else {
        throw FormatException('Invalid JWT token format');
      }
    } catch (error) {
      throw FormatException('Error decoding JWT token: $error');
    }
  }

  void fetchProfile() {
    String base64EncodedProfileInfo = widget.profileInfo.toString();

    try {
      Map<String, dynamic> profileData = decodeJWTToken(base64EncodedProfileInfo);

      // Now you can access the profile data
      print('Profile Data:');
      print(profileData);

      userName = profileData['cn'];
      profileEmail = profileData['em'];
      profilePhone = profileData['mb'];

    } catch (error) {
      print(error);
    }


  }



  Future<void> _fetchCompany() async {
    fetchProfile();


    // API endpoint URL
    final String apiUrl = '${config.baseUrl}clients/v1/view/payment/config';

    // Request headers
    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
      'X-Token-Key': widget.accessToken,
    };

    try {
      // Send the API request
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,

      );

      // Parse the response JSON
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check the response status
      if (response.statusCode == 200 && responseData['code'] == 'Success') {
        // Successful authentication, initiate second level authentication
        print(responseData);
        // Successful login verification
         companyName = responseData['data']['data']['name'];


      } else {
        // Failed authentication
        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Fetch Failed: $errorMessage');
      }
    } catch (error) {
      print('Error occurred while calling the 1API: $error');
    }

  }


  Future<void> _fetchBalance() async {


    // API endpoint URL
    final String apiUrl = '${config.baseUrl}dashboard/v1/client/summary';

    // Request headers
    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
      'X-Token-Key': widget.accessToken,
    };

    try {
      // Send the API request
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,

      );

      // Parse the response JSON
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check the response status
      if (response.statusCode == 200 && responseData['code'] == 'Success') {
        // Successful authentication, initiate second level authentication
        print(responseData);
        // Successful login verification
        var data = responseData['data']['data']['data']['data'][0];
        availableBalance = data['avaliableBalance'].toString();
        currency = data['currency'];


      } else {
        // Failed authentication
        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Fetch Failed: $errorMessage');
      }
    } catch (error) {
      print('Error occurred while calling the 2API: $error');
    }

  }



  Future<void> _fetchCommission() async {


    // API endpoint URL
    final String apiUrl = '${config.baseUrl}dashboard/v1/view/commmsion';

    // Request headers
    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
      'X-Token-Key': widget.accessToken,
    };

    try {
      // Send the API request
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,

      );

      // Parse the response JSON
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check the response status
      if (response.statusCode == 200 && responseData['code'] == 'Success') {
        // Successful authentication, initiate second level authentication
        print(responseData);
        // Successful login verification
        // var data = responseData['data']['data']['data']['data'][0];
        // availableBalance = data['avaliableBalance'].toString();
        // currency = data['currency'];
        //commission = responseData['data']['data']['confirmCommission'];
        var commissionData = responseData['data']['data'][0];
        commission = commissionData['confirmCommission'];


      } else {
        // Failed authentication
        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Fetch Failed: $errorMessage');
      }
    } catch (error) {
      print('Error occurred while calling the 3API: $error');
    }

  }



  // Future<List<dynamic>> _fetchTransactions() async {
  //   // API endpoint URL
  //   final String apiUrl = '${config.baseUrl}payments/v1/view?start=2023-05-01&end=2023-07-01&status=1';
  //
  //   // Request headers
  //   Map<String, String> headers = {
  //     'X-App-Key': config.appKey,
  //     'X-Authorization-Key': config.authorizationKey,
  //     'X-Requested-With': config.requestedWith,
  //     'Content-Type':  config.contentType,
  //     'X-Token-Key':  widget.accessToken,
  //   };
  //
  //   // Request parameters
  //   // Map<String, String> parameters = {
  //   //   'start': '2023-06-01',
  //   //   'end': '2023-07-30',
  //   // };
  //
  //   try {
  //     // Send the API request
  //     http.Response response = await http.get(
  //       Uri.parse(apiUrl),
  //       headers: headers,
  //
  //     );
  //
  //     // Parse the response JSON
  //     Map<String, dynamic> responseData = jsonDecode(response.body);
  //
  //     // Check the response status
  //     if (response.statusCode == 200 && responseData['code'] == 'Success') {
  //      // print(responseData);
  //       print("trans fetched");
  //       // Successful API request, extract the transactions data
  //       List<dynamic> transactions = responseData['data']['data'];
  //       print('transactions are {$transactions}');
  //
  //       // Filter transactions based on status
  //
  //
  //       List<dynamic> successfulTransactions1 = transactions
  //           .where((transaction) => transaction['status'].trim() == '1')
  //           .toList();
  //
  //
  //
  //       List<dynamic> pendingTransactions1 = transactions
  //           .where((transaction) => transaction['status'] == '2')
  //           .toList();
  //
  //       successfulTransactions = successfulTransactions1;
  //       pendingTransactions = pendingTransactions1;
  //
  //
  //
  //       print('success are $successfulTransactions');
  //       print('pending are {$pendingTransactions}');
  //       // Return both lists
  //       return [successfulTransactions1, pendingTransactions1];
  //
  //      // successfulTransactions = successfulTransactions1;
  //     } else {
  //       // Failed API request
  //       String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
  //       print('Fetch Failed: $errorMessage');
  //       throw Exception('API request failed');
  //     }
  //   } catch (error) {
  //     print('Error occurred while calling the API: $error');
  //     throw Exception('API request failed');
  //   }
  // }



  Future<List<dynamic>> _fetchTransactionsByStatus(String apiUrl, Map<String, String> headers) async {
    try {
      // Send the API request
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      // Parse the response JSON
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check the response status
      if (response.statusCode == 200 && responseData['code'] == 'Success') {
        // Successful API request, extract the transactions data
        List<dynamic> transactions = responseData['data']['data'];
        // Return the transactions list


        return transactions;
      } else {
        // Failed API request
        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Fetch Failed: $errorMessage');
        throw Exception('API request failed');
      }
    } catch (error) {
      print('Error occurred while calling the API: $error');
      throw Exception('API request failed');
    }
  }




  // Function to fetch successful transactions
  Future<List<dynamic>> fetchSuccessfulTransactions() async {
    final String apiUrl = config.successfulTransactions;

    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
      'X-Token-Key': widget.accessToken,
    };

    // Call the helper function to fetch successful transactions
    return _fetchTransactionsByStatus(apiUrl, headers);
  }

// Function to fetch pending transactions
  Future<List<dynamic>> fetchPendingTransactions() async {
    final String apiUrl = config.pendingTransactions;

    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
      'X-Token-Key': widget.accessToken,
    };

    // Call the helper function to fetch pending transactions
    return _fetchTransactionsByStatus(apiUrl, headers);
  }


  String formatCurrency(double amount) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '', //
      decimalDigits: 2,
    );
    return currencyFormat.format(amount);
  }






  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _fetchData(),  // The method that fetches all the required data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While data is being fetched, show a CircularProgressIndicator

              return LoadingHomeScreen(size: size);




            } else if (snapshot.hasError) {
              //performLogout();
              // If an error occurred during fetching
                return Center(

                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60,),
                        Text("Your session has expired,", style: GoogleFonts.inter(fontSize: 16, color: Colors.black,),),
                        SizedBox(height: 5,),
                        Text("Please login again", style: GoogleFonts.inter(fontSize: 16, color: Colors.black,),),
                        SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async {
                        await _storage.deleteAll();
                        // Navigate to the login screen and replace the current screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text('Login Again', style: whiteText,),
                      style: ButtonStyleConstants.primaryButtonStyle,
                    ),
                    ])
                  ),
                );
            } else {

              // If data has been fetched successfully, show the home screen content
              return Column(
                children: [
                  Container(
                      //height: size.height * 0.35,
                      height: 270,
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
                                'Hello there,${userName}',
                                style: bodyTextWhite,
                              ),
                              Text(
                                companyName?? '',
                                style: whiteText,
                              )
                            ]),
                          ]),
                          Row(children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(currency??'', style: whiteText,),
                              style: TextButton.styleFrom(
                                  backgroundColor: Color(0xff00284A),
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                            ),
                            IconButton(
                              icon: Icon(
                                _obscureBalance ? Icons.visibility : Icons.visibility_off,
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
                          Visibility(
                            visible: _obscureBalance,
                            replacement: Text(
                              '*******', // Show asterisks when obscured
                              style: mainHeading,
                            ),
                            child:
                            Text(
                              '${currency ?? ''} ${formatCurrency(double.tryParse(availableBalance ?? '0.0') ?? 0.0)}',
                              style: mainHeading,
                            )

                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                              text: "Commission:",
                              style: bodyTextWhite,
                            ),
                            TextSpan(
                              text: ' ${formatCurrency(double.tryParse(commission ?? '0.0')?? 0.00)}',
                              style: bodyTextWhite,
                            )
                          ]))
                        ])
                      ])),

                  Column(children: [
                    Container(
                      height: 100,
                      width: size.width * 1,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SendMoneyScreen(profileInfo: widget.profileInfo, accessToken: widget.accessToken,)));
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

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PendingTransactionsScreen(pendingTransactions: pendingTransactions),
                          ),
                        );
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          width: size.width * 1,
                          child: GestureDetector(
                            onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => PendingTransactionsScreen(pendingTransactions: pendingTransactions),
            ),
            );
                            },
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
                                      onPressed: () {
                                      },
                                      child: Text(
            pendingTransactions.length.toString(),
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
                            ),
                          )
                      ),
                    ),

                    Divider(color: Colors.grey,  thickness: 1,),
                    Container(

                        child: Text("Transactions", style: bodyTextBlackBigger,textAlign: TextAlign.start,)),
                    if (successfulTransactions.isEmpty)
                      Container(
                        height: 500,
                        width: size.width * 1,
                        child: Center(
                          child: Text('No successful transactions found.'),
                        ),
                      )
                    else
                      
                    Container(
                      height: size.height * 0.7,
                      width: size.width * 1,


                      child: ListView.builder(

                          padding: EdgeInsets.zero,
                          itemCount: successfulTransactions.length,
                          itemBuilder: (context, index) {
                            var transaction = successfulTransactions[index];
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
                              title: Text(transaction['beneficiaryName'], style: bodyTextBlackBigger,),
                              subtitle: Text(transaction['created_at'], style: bodyTextBlack,),
                              trailing: Text(
                                '${transaction['currencyReceive']} ${formatCurrency(double.tryParse(transaction['amount']) ?? 0.0)}',
                                style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700),
                              ),

                            );
                          }),
                    )




                  ])
                ],
              );
            }
          },
        ),
      ),
    );
  }




// Helper method to fetch all required data
  Future<void> _fetchData() async {
    try {
      List<dynamic> successfulTransactions1 = await fetchSuccessfulTransactions();
      List<dynamic> pendingTransactions1 = await fetchPendingTransactions();

      successfulTransactions = successfulTransactions1;
      pendingTransactions = pendingTransactions1;

      // Do whatever you need with the fetched transactions
      print('Successful Transactions: $successfulTransactions');
      print('Pending Transactions: $pendingTransactions');
    } catch (error) {
      performLogout();
      // Handle errors here
    }


    // Fetch data simultaneously using Future.wait()
    final List<Future<void>> futures = [
      _fetchCompany(),
      _fetchBalance(),
      _fetchCommission(),

    ];

    // Wait for all data to be fetched before returning
    await Future.wait(futures);
  }

  Future<void> performLogout() async {

    await _storage.deleteAll();


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

// ... rest of your existing code ...






}

class LoadingHomeScreen extends StatelessWidget {
  const LoadingHomeScreen({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
                  children: [
                    Container(
                      //height: size.height * 0.35,
                        height: 270,
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
                                   '',
                                  style: whiteText,
                                )
                              ]),
                            ]),
                            Row(children: [
                              TextButton(
                                onPressed: () {},
                                child: Text('KES', style: whiteText,),
                                style: TextButton.styleFrom(
                                    backgroundColor: Color(0xff00284A),
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    )),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {

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

                                Text('Loading...',
                                  style: mainHeading,
                                ),



                            SizedBox(
                              height: 10,
                            ),
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                text: "Commission:",
                                style: bodyTextWhite,
                              ),
                              TextSpan(
                                text: ' ',
                                style: bodyTextWhite,
                              )
                            ]))
                          ])
                        ])),

                    Column(children: [
                      Container(
                        height: 100,
                        width: size.width * 1,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: GestureDetector(
                                onTap: () {

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


                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 50,
                            width: size.width * 1,
                            child: GestureDetector(
                              onTap: () {

                              },
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
                                        onPressed: () {
                                        },
                                        child: Text(
                                          '',
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
                              ),
                            )
                        ),
                      ),

                      Divider(color: Colors.grey,  thickness: 1,),
                      Container(

                          child: Text("Transactions", style: bodyTextBlackBigger,textAlign: TextAlign.start,)),

                        Container(
                          height: size.height * 0.7,
                          width: size.width * 1,


                          child:ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder:  (context, index) {
                                return Container(
                                  height: size.height * 0.1,
                                  width: size.width * 1,
                                  child:  Card(
                                    color: Colors.blueGrey.withOpacity(0.5),

                                  )
                                );
                              }
                          )

                        )

                    ])
                  ],
                );
  }
}
