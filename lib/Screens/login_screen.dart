import 'package:agency_app/Screens/navigation.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final  _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePin = true;



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
            child: Padding(
              padding: EdgeInsets.all(20),
              child:
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height*0.3 ,),
                    Text(
                      "Login",
                      style: GoogleFonts.inter(fontSize: 32.0, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: bodyTextWhite,

                      ),
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
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


                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {

                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NavPage()));
                          //TODO: Login
                        }
                        // Perform login action
                      },
                      child: Text('Login', style: whiteText,),
                      style: ButtonStyleConstants.primaryButtonStyle,
                    ),
                  ],
                ),

              ),



            )
        ));
  }
}
