import 'dart:convert';


import 'package:agency_app/Screens/User%20authentication/reset_password_screen.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agency_app/config.dart' as config;

import 'package:http/http.dart' as http;


class RequestOTPScreen extends StatefulWidget {
  RequestOTPScreen({Key? key}) : super(key: key);

  @override
  State<RequestOTPScreen> createState() => _RequestOTPScreenState();
}

class _RequestOTPScreenState extends State<RequestOTPScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();




  Future<void> _requestOTP() async {
    final phone = formatNumber(_phoneNumberController.text);

    // Validate the phone number
    if (_formKey.currentState!.validate()) {
      await _storage.write(key: 'phone_number', value: phone);
      print(phone);

      // Send the OTP request
      try {
        final url = Uri.parse('${config.baseUrl}auth/v1/reset');
        final headers = {
          'X-App-Key': config.appKey,
          'X-Authorization-Key': config.authorizationKey,
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/json',
        };
        final body = {
          'user_name': phone,
          'country_code': 'KEN',
        };

        final response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        print(response.body);

        if (response.statusCode == 200) {
          // OTP request success, navigate to the OTP confirmation screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(),
            ),
          );
        } else {
          // OTP request failed, show an error dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Invalid Phone number. Please try again.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Error');
        // Handle and show an error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred. Please try again later.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final size =  MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFF00284A),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back, color: Colors.white,
          ),

        ),
        title: Text(
          'Request OTP',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

      ),

        body: Container(

          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          width: double.infinity,
          height: double.infinity,
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
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(

                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 16,),
                              Text('Enter your phone number to receive an OTP',
                                style:  whiteText,
                                textAlign: TextAlign.center,),
                              SizedBox(height: 32,),
                              TextFormField(
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.inter( fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white, width: 2),
                                  ),
                                  labelText: 'Phone number',
                                  labelStyle: GoogleFonts.inter( fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your phone number';
                                  }

                                  // additional validation logic for the phone number
                                  return null;
                                },
                                // onSaved: (value) {
                                //   _phone = value;
                                // }
                              ),
                              SizedBox(height: 32,),

                              ElevatedButton(
                                onPressed:
                                () {
                                  if (_formKey.currentState!.validate()) {
                                    _requestOTP();
                                  }
                                },
                                style: ButtonStyleConstants.primaryButtonStyle,
                                child: Text('Request OTP'),
                              ),
                            ])

              )
          ),
        ));
  }

  String formatNumber(String phone) {
    if (phone.isEmpty) {
      return '';
    }

    if (phone.startsWith('+') || phone.startsWith('0')) {
      phone = phone.substring(1);
    }

    if (phone.length <= 8) {
      return '';
    }

    String subst = phone.substring(0, 4);

    if (subst.startsWith('+254')) {
      return phone.substring(1);
    } else if (subst.startsWith('0')) {
      return '254${phone.substring(1)}';
    } else if (phone.startsWith('254')) {
      return phone;
    } else {
      return '254$phone';
    }
  }

}

