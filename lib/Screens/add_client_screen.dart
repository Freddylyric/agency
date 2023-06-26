import 'package:agency_app/Screens/payment_details_bottomsheet.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/material.dart';

class AddClientScreen extends StatefulWidget {
  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  String selectedCountry = 'Kenya';
  String selectedBank = 'Kenya Commercial Bank';
  String selectedClientOption = '';
  String selectedAccountOption = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  List<String> countries = ['Kenya', 'Country 2', 'Country 3', 'Country 4'];
  List<String> banks = ['Kenya Commercial Bank', 'bank 2', 'bank 3', 'bank 4'];


  List<String> clientOptions = ['Sender', 'Receiver' ,];
  List<String> accountOptions = ['Bank', 'Mobile Money', 'Pick Up'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),//IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text('Add Client', style: bodyTextBlackBigger,),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
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
                  labelText: 'Recipient Country',labelStyle: bodyTextBlackBigger,
                ),
              ),
              SizedBox(height: 8),
          Text("Type of client",style: bodyTextBlackBigger),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedClientOption = clientOptions[0];
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: selectedClientOption == clientOptions[0]
                        ? Colors.blue
                        : Colors.grey.withOpacity(0.2),
                  ),
                  child: Text('Sender', style: selectedClientOption == clientOptions[0]
                      ? bodyTextWhite
                      : bodyTextBlack),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedClientOption = clientOptions[1];
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: selectedClientOption == clientOptions[1]
                        ? Colors.blue
                        : Colors.grey.withOpacity(0.2),
                  ),
                  child: Text('Receiver', style: selectedClientOption == clientOptions[1]
                      ? bodyTextWhite
                      : bodyTextBlack),
                ),
              ),
              ]
          ),

              TextFormField(
                controller: _nameController,
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
                          selectedAccountOption = accountOptions[0];
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedAccountOption == accountOptions[0]
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.2),
                      ),
                      child: Text('Bank', style: selectedAccountOption == accountOptions[0]
                          ? bodyTextWhite
                          : bodyTextBlack),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedAccountOption = accountOptions[1];
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedAccountOption == accountOptions[1]
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.2),
                      ),
                      child: Text('Mobile Money', style: selectedAccountOption == accountOptions[1]
                          ? bodyTextWhite
                          : bodyTextBlack),
                    ),
                  ),
                  SizedBox(width: 10,),

                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedAccountOption = accountOptions[2];
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedAccountOption == accountOptions[2]
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.2),
                      ),
                      child: Text('Pick Up',style: selectedAccountOption == accountOptions[2]
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
                 // TODO: ADD Client
                },
                child: Text('Add client', style: whiteText,),
                style: ButtonStyleConstants.primaryButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}