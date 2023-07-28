import 'dart:convert';
import 'package:agency_app/Screens/User%20authentication/request_otp_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:agency_app/Screens/navigation.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'otp_verification_screen.dart';
import 'package:agency_app/config.dart' as config;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePin = true;
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();



  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final phoneNumber = formatNumber(phoneNumberController.text);
    final password = passwordController.text;
    print(phoneNumber);
    print(password);
    await _storage.write(key: 'password', value: password);
    await _storage.write(key: 'phone_number', value: phoneNumber);

    // API endpoint URL
    final String apiUrl = '${config.baseUrl}auth/v1/login';

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
      'country_code': 'KEN',
      'password': password,
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
        // Successful authentication, initiate second level authentication
        print('Authentication validated successfully.');
        print('OTP sent via email / SMS. Verify account to continue.');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OTPScreen()),
        );
      } else {
        // Failed authentication
        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Authentication failed: $errorMessage');
        //show a snackbar for wrong username/password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Wrong username/password. Please try again"),
            backgroundColor: Colors.red,
          ),
        );

      }
    } catch (error) {
      print('Error occurred while calling the API: $error');
      //show snackbar for wrong username/password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please try again later"),
          backgroundColor: Colors.red,
        ),
      );

    }

    setState(() {
      _isLoading = false;
    });
  }


  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 200),
                Text(
                  "Login",
                  style: GoogleFonts.inter(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: bodyTextWhite,
                      ),
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      onEditingComplete: _handleLogin
                  ),

                  SizedBox(height: 16.0),
                  TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: bodyTextWhite,
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
                      style: TextStyle(color: Colors.white),
                      obscureText: _obscurePin,
                      onEditingComplete: _handleLogin,

                  ),
                  SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestOTPScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: bodyTextWhite,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  //Spacer(),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ButtonStyleConstants.primaryButtonStyle,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  ),
                  SizedBox(height: 20),
                    ]
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    } else  {
      return '254$phone';
    }
  }
}
