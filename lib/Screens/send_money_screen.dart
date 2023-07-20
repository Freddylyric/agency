import 'package:agency_app/Screens/home_screen.dart';
import 'package:agency_app/Screens/navigation.dart';
import 'package:agency_app/Screens/payment_details_bottomsheet.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/material.dart';

class SendMoneyScreen extends StatefulWidget {
  final profileInfo;
  final accessToken;
  const SendMoneyScreen({Key? key,required this.profileInfo,required this.accessToken}) : super(key: key);

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  String selectedCountry = 'Kenya';
  String selectedBank = 'Kenya Commercial Bank';
  String selectedSendToOption = '';

  final TextEditingController _youSendController = TextEditingController();
  final TextEditingController _theyReceiveController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  List<String> countries = ['Kenya', 'Country 2', 'Country 3', 'Country 4'];
  List<String> banks = ['Kenya Commercial Bank', 'bank 2', 'bank 3', 'bank 4'];


  List<String> sendToOptions = ['Bank', 'Mobile Money', 'Pick Up'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NavPage(profileInfo: widget.profileInfo, accessToken: widget.accessToken,)));
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),//IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text('Send Money', style: bodyTextBlackBigger,),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCountry,
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value!;
                  });
                },
                items: countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country, style: blueText,),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Recipient Country', labelStyle: bodyTextBlackBigger,
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _youSendController,
                      decoration: InputDecoration(
                        labelText: 'You Send', labelStyle: bodyTextBlackBigger,
                          border:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          )
                      ),
                      style: blueText,
                    ),

                  ),

                  Expanded(
                    child: TextFormField(
                      controller: _theyReceiveController,
                      decoration: InputDecoration(
                        labelText: 'They Receive',labelStyle: bodyTextBlackBigger,
                          border:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          )
                      ),
                      style: blueText,
                    ),
                  ),
                ],
              ),

              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Names',labelStyle: bodyTextBlackBigger,
                ),
                style: blueText,
              ),

              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',labelStyle: bodyTextBlackBigger,
                ),
                style: blueText,
              ),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',labelStyle: bodyTextBlackBigger,
                ),
                style: blueText,
              ),
              SizedBox(height: 8),
              Text("Send to",style: bodyTextBlackBigger),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedSendToOption = sendToOptions[0];
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedSendToOption == sendToOptions[0]
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.2),
                      ),
                      child: Text('Bank', style: selectedSendToOption == sendToOptions[0]
                          ? bodyTextWhite
                          : bodyTextBlack),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedSendToOption = sendToOptions[1];
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedSendToOption == sendToOptions[1]
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.2),
                      ),
                      child: Text('Mobile Money', style: selectedSendToOption == sendToOptions[1]
                          ? bodyTextWhite
                          : bodyTextBlack),
                    ),
                  ),
                  SizedBox(width: 10,),

                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedSendToOption = sendToOptions[2];
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedSendToOption == sendToOptions[2]
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.2),
                      ),
                      child: Text('Pick Up',style: selectedSendToOption == sendToOptions[2]
                          ? bodyTextWhite
                          : bodyTextBlack),
                    ),
                  ),
                ],
              ),

              DropdownButtonFormField<String>(
                value: selectedBank,
                onChanged: (value) {
                  setState(() {
                    selectedBank = value!;
                  });
                },
                items: banks.map((bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(bank, style: blueText,),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Bank name',labelStyle: bodyTextBlackBigger,
                ),
              ),

              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',labelStyle: bodyTextBlackBigger,
                ),
                style: blueText,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentDetailsBottomSheet(
                        amount: '100',
                        youSend: '75',
                        theyReceive: '9000',
                        userName: 'John Doe',
                        deliveryMode: 'Bank Account',
                        accountNumber: '1234567890',
                      );
                    },
                  );
                },
                child: Text('Send Money', style: whiteText,),
                style: ButtonStyleConstants.primaryButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}