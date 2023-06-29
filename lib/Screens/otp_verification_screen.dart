
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Utils/utils.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);





  @override
  State<OTPScreen> createState() => _OTPScreenState();
}



class _OTPScreenState extends State<OTPScreen> {


  final _storage = const FlutterSecureStorage();
  late String storedValue;
  final countryCode = 'KEN';



  Future<void> _verifyOTP (String phoneNumber, String countryCode, String verificationCode) async {
    // API endpoint URL
    final String apiUrl = 'https://api.example.com/auth/v1/login';

    // Request headers
    Map<String, String> headers = {
      'X-App-Key': 'your_app_key',
      'X-Authorization': 'your_channel_key',
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
        // Successful login verification
        String userLevel = responseData['data']['user_level'];
        String profileInfo = responseData['data']['profile_info'];
        String systemKey = responseData['data']['system_key'];
        String ipAddress = responseData['data']['ip']['IP'];
        String accessToken = responseData['data']['token'];

        print('Successfully updated!');
        print('User Level: $userLevel');
        print('Profile Info: $profileInfo');
        print('System Key: $systemKey');
        print('IP Address: $ipAddress');
        print('Access Token: $accessToken');
      } else {
        // Failed login verification
        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Login verification failed: $errorMessage');
      }
    } catch (error) {
      print('Error occurred while calling the API: $error');
    }
  }



  @override
  void initstate() {
    _getPhoneNumber();
    super.initState();
  }


  Future<void> _getPhoneNumber() async {
    storedValue = (await _storage.read(key: 'phone_number'))!;
    setState(() {});
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,


              children: [
                Text("CO\nDE",style: GoogleFonts.montserrat( fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
                Text("Verification", style: mainHeading,),
                SizedBox(height: 10,),
                Text("Enter the OTP verification code sent", textAlign: TextAlign.center, style: subHeading,),
                SizedBox(height: 20,),

                OtpTextField(
                  numberOfFields: 6,
                  fillColor: Colors.black.withOpacity(0.1),
                  filled: true,
                  onSubmit: (code){

                    print("OTP is" + code);
                    _verifyOTP(storedValue, countryCode, code);

                  },

                ),
                SizedBox(height: 30,),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: (){}, child: Text("NEXT", style: whiteText,),
                      style: ButtonStyleConstants.secondaryButtonStyle,)),


              ],

            )

        )
    );
  }
}
