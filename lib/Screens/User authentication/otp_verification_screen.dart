
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';
import 'package:agency_app/config.dart' as config;

import '../home_screen.dart';
import '../navigation.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);





  @override
  State<OTPScreen> createState() => _OTPScreenState();
}



class _OTPScreenState extends State<OTPScreen> {


  final _storage = const FlutterSecureStorage();
  TextEditingController _otpController = TextEditingController();
  late String phoneNumber = '';
  late String storedValue;
  final countryCode = 'KEN';
  late String verCode ='';




  @override
  void initState() {
    _getPhoneNumber();
    super.initState();
  }


  Future<void> _getPhoneNumber() async {
    storedValue = (await _storage.read(key:'phone_number'))!;


    setState(() {
      phoneNumber = storedValue;
    });
  }



  Future<void> _verifyOTP(String phoneNumber, String countryCode, String verificationCode) async {
    print(phoneNumber);
    print(verificationCode);
    print(countryCode);

    // API endpoint URL
    final String apiUrl = '${config.baseUrl}auth/v1/verify/login';

    // Request headers
    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json',
    };

    // Request body
    Map<String, String> requestBody = {
      'user_name': phoneNumber,
      'country_code': countryCode,
      'verification_code': verificationCode,
    };

    try {
      // Send the API request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Parse the response JSON
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check the response status
      if (response.statusCode == 200 && responseData['code'] == 'Success') {
        print(responseData);
        // Successful login verification
        String? userLevel = responseData['data']['data']['user_level'];
        String? profileInfo = responseData['data']['data']['profile_info'];
        String? systemKey = responseData['data']['data']['system_key'];
        String? ipAddress = responseData['data']['data']['ip']?['IP'];
        String? accessToken = responseData['data']['data']['token'];
        int? authorized = responseData['data']['data']['ip']?['authorized'];
        int? has = responseData['data']['data']['ip']?['has'];

        print('Successfully updated!');
        print('User Level: $userLevel');
        print('Profile Info: $profileInfo');
        print('System Key: $systemKey');
        print('IP Address: $ipAddress');
        print('Access Token: $accessToken');
        print('authorized: $authorized');
        print('has: $has');

        await _storage.write(key: 'X-Token', value: accessToken);
        await _storage.write(key: 'client_whitelistIps', value: ipAddress);

        if (authorized == 1 && has == 1) {
          // User has authorized access and can proceed to the home screen

          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>  NavPage(profileInfo: profileInfo!, accessToken: accessToken!,)));

        } else if (authorized == null && has == 1) {
          // User is not authorized, but has the right to add IP
          _addIPToWhitelist(ipAddress!, accessToken!, profileInfo!);
          // Display a success message
        } else {
          // User is not authorized and does not have the right to add IP
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You are not authorized")),
          );

          Navigator.pop(context);


        }


      } else {
        // Failed login verification
        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('VLogin verification failed: $errorMessage');
      }
    } catch (error) {
      print('VError occurred while calling the API: $error');
    }
  }





  Future<void> _addIPToWhitelist(String ipAddress, String accessToken, String profileInfo ) async {
    // API endpoint URL
    final String apiUrl = '${config.baseUrl}clients/v1/add/ip';
    final String storedToken = _storage.read(key: 'X-Token')!.toString();
    final String storedIPAddress = _storage.read(key: 'client_whitelistIps')!.toString();

    // Request headers
    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json',
      'X-Token-Key': accessToken,
    };

    // Request body
    Map<String, dynamic> requestBody = {
      'client_whitelistIps': [ipAddress],
    };

    try {
      // Send the API request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Parse the response JSON
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check the response status
      if (response.statusCode == 200 && responseData['code'] == 'Success') {
        // IP address added successfully
        print('IP address added successfully');

        Navigator.push(context, MaterialPageRoute(builder: (context)=> NavPage(profileInfo: profileInfo, accessToken: accessToken,)));
      } else {
        // Failed to add IP address
        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Failed to add IP address: $errorMessage');
      }
    } catch (error) {
      print('Error occurred while calling the API: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(


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

            )
          ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,


                children: [
                  Text("OTP",style: GoogleFonts.montserrat( fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Verification", style: mainHeading,),
                  SizedBox(height: 10,),
                  Text("Enter the OTP verification code sent", textAlign: TextAlign.center, style: subHeading,),
                  SizedBox(height: 20,),

                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.visiblePassword,
                    style: GoogleFonts.inter( fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      labelText: 'OTP',
                      labelStyle: GoogleFonts.inter( fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your OTP';
                      }

                      // additional validation logic for the phone number
                      return null;
                    },
                    onEditingComplete:
                    () async {
                      if (_otpController.text.length == 6) {
                        await _verifyOTP(phoneNumber, countryCode, _otpController.text);
                      }
                    },
                    onFieldSubmitted:
                    (value) {
                      verCode = value;
                      verCode = _otpController.text;
                      print("OTP is $verCode");

                      _verifyOTP(phoneNumber, countryCode, value);
                    },


                  ),



                  // OtpTextField(
                  //   numberOfFields: 6,
                  //   fillColor: Colors.white.withOpacity(0.1),
                  //   showFieldAsBox: true,
                  //   filled: true,
                  //   textStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 16.0),
                  //   keyboardType: TextInputType.text, // Set the keyboardType to accept alphanumeric input
                  //   onSubmit: (code) {
                  //     verCode = code;
                  //
                  //     print("OTP is $code");
                  //     _verifyOTP(phoneNumber, countryCode, verCode);
                  //     // _verifyOTP(storedValue, countryCode, code);
                  //   },
                  // ),


                  SizedBox(height: 30,),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: (){
                        verCode = _otpController.text;

                        _verifyOTP(phoneNumber, countryCode, verCode);
                      }, child: Text("NEXT", style: whiteText),
                        style: ButtonStyleConstants.primaryButtonStyle,)),


                ],

              ),
            )

        )
    );
  }
}
