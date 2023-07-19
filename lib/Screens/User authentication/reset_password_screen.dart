import 'dart:convert';

import 'package:agency_app/Screens/User%20authentication/request_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:agency_app/Utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agency_app/config.dart' as config;


import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  TextEditingController _pinController = TextEditingController();
  TextEditingController _confirmPinController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  // final _pinController = TextEditingController();
  // final _confirmPinController = TextEditingController();
  // final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;

  final _storage = const FlutterSecureStorage();
  late String storedValue;
  String _message = '';

  String? _pin;
  String? _otp;

  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
    _message = '';
  }

  Future<void> _getPhoneNumber() async {
    storedValue = (await _storage.read(key: 'phone_number'))!;
    setState(() {});
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final pin = _pinController.text;
    final pin2 = _confirmPinController.text;
    final otp = _otpController.text;

    print(storedValue);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse('${config.baseUrl}auth/v1/verify');
      final headers = {
        'X-App-Key': config.appKey,
        'X-Authorization-Key': config.authorizationKey,
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json',
      };
      final body = {
        'user_name': storedValue,
        'country_code': 'KEN',
        'new_password': pin2,
        'verification_code': otp,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Password reset failed, show an error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to reset password. Please try again later.'),
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
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00284A),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Reset your PIN', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
      ),
      body: Container(
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
        child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),

                      // Phone number input field
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

                      ),
                      const SizedBox(height: 30),


                      // Pin input field
                      TextFormField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        obscureText: _obscurePin,
                        style: GoogleFonts.inter( fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                          labelText: 'New Password',
                          labelStyle: GoogleFonts.inter( fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePin ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePin = !_obscurePin;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your PIN';
                          }
                          // Add any additional validation logic for the PIN here
                          return null;
                        },

                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _confirmPinController,
                        keyboardType: TextInputType.number,
                        obscureText: _obscureConfirmPin,
                        style: GoogleFonts.inter( fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                          labelText: 'Confirm New Password',
                          labelStyle: GoogleFonts.inter( fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPin ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPin = !_obscureConfirmPin;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _pinController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
// Log in button
                      ElevatedButton(
                        onPressed: () {
                           if (_formKey.currentState!.validate()) {
                          resetPassword();
                          // Add login logic here
                           }
                        },
                        style: ButtonStyleConstants.primaryButtonStyle,
                        child: Text('RESET PIN', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                      ),

                      const SizedBox(height: 30),
                      // Forgot PIN text
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RequestOTPScreen()));
                        },
                        child: Text(
                          'Request OTP',
                          style: GoogleFonts.inter( fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
