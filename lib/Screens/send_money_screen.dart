import 'package:agency_app/Screens/home_screen.dart';
import 'package:agency_app/Screens/navigation.dart';
import 'package:agency_app/Screens/payment_details_bottomsheet.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import 'add_client_screen.dart';







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
  String selectedSenderCurrency = 'KES';
  String selectedBeneficiaryCurrency = 'KES';

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _pickupLocationController = TextEditingController();
  final TextEditingController _purposeOfPaymentController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _theyReceiveController = TextEditingController();
  final TextEditingController _conversionRateController = TextEditingController();
  final TextEditingController _transactionFeeController = TextEditingController();

  List<String> countries = ['Kenya', 'Country 2', 'Country 3', 'Country 4'];
  List<String> banks = ['Kenya Commercial Bank', 'bank 2', 'bank 3', 'bank 4'];
  List<String> currencies = ['KES', 'USD', 'EUR', 'GBP'];
  List<dynamic> users = ['Fred Kairu', 'user 2', 'user 3', 'user4'];

  String? selectedSender;
  String? selectedBeneficiary;

  List<String> sendToOptions = ['Bank', 'Mobile Money', 'Pick Up'];

  late String sender;

  @override
  Widget build(BuildContext context) {
    final size =  MediaQuery.of(context).size;
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
              SizedBox(height: 10,),
              // ... (existing code remains the same) ...


              // SearchField(
              //   suggestions:countries
              //       .map((e) => SearchFieldListItem(e))
              //       .toList(),
              //   suggestionState: Suggestion.expand,
              //   textInputAction: TextInputAction.next,
              //   hint: 'Recipient Country',
              //   searchStyle: TextStyle(
              //     fontSize: 14,
              //     color: Colors.black.withOpacity(0.8),
              //   ),
              //   validator: (x) {
              //     if (!users.contains(x) || x!.isEmpty) {
              //       return 'Please enter a valid Country';
              //     }
              //     return null;
              //   },
              //   searchInputDecoration: InputDecoration(
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       borderSide: BorderSide(
              //         color: Colors.black.withOpacity(0.8),
              //       ),
              //     ),
              //     border: OutlineInputBorder(
              //
              //       borderSide: BorderSide(color: Colors.red),
              //     ),
              //   ),
              //   maxSuggestionsInViewPort: 6,
              //   itemHeight: 40,
              //   onSubmit:
              //       (x) {
              //     setState(() {
              //       sender=  x;
              //     });
              //   },
              //   // onTap: (x) {
              //   //   setState(() {
              //   //
              //   //   })
              //   // },
              // ),
              // SizedBox(height: 10,),

              SearchField(
                suggestions: users
                    .map((e) => SearchFieldListItem(e))
                    .toList(),
                suggestionState: Suggestion.expand,
                textInputAction: TextInputAction.next,
                hint: 'Select/Search Sender',
                searchStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.8),
                ),
                validator: (x) {
                  if (!users.contains(x) || x!.isEmpty) {
                    return 'Please enter a valid User';
                  }
                  return null;
                },
                searchInputDecoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: () {
                    showDialog(context:
                    context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Add a Client', textAlign: TextAlign.center,),

                            content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text('Close', style: whiteText,),
                                    style:  ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.red),
                                    ),

                                  ),

                                  TextButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddClientScreen()));
                                  }, child: Text('Okay', style: whiteText,),
                                    style:  ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.green),

                                    ),

                                  ),
                                ]
                            ),
                          );
                        });
                  }, icon: Icon(Icons.add_circle_outline, color: Colors.blue,)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  border: OutlineInputBorder(

                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                maxSuggestionsInViewPort: 6,
                itemHeight: 40,
                onSubmit:
                    (x) {
                  setState(() {
                    sender=  x;
                  });
                },
                // onTap: (x) {
                //   setState(() {
                //
                //   })
                // },
              ),
              SizedBox(height: 10,),


              SearchField(
                suggestions: users
                    .map((e) => SearchFieldListItem(e))
                    .toList(),
                suggestionState: Suggestion.expand,
                textInputAction: TextInputAction.next,
                hint: 'Select/Search Beneficiary',
                searchStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.8),
                ),
                validator: (x) {
                  if (!users.contains(x) || x!.isEmpty) {
                    return 'Please enter a valid User';
                  }
                  return null;
                },
                searchInputDecoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: () {
                    showDialog(context:
                    context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Add a Client', textAlign: TextAlign.center,),

                            content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text('Close', style: whiteText,),
                                    style:  ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.red),
                                    ),

                                  ),

                                  TextButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddClientScreen()));
                                  }, child: Text('Okay', style: whiteText,),
                                    style:  ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.green),

                                    ),

                                  ),
                                ]
                            ),
                          );
                        });
                  }, icon: Icon(Icons.add_circle_outline, color: Colors.blue,)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  border: OutlineInputBorder(

                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                maxSuggestionsInViewPort: 6,
                itemHeight: 40,
                onSubmit:
                    (x) {
                  setState(() {
                    sender=  x;
                  });
                },
                // onTap: (x) {
                //   setState(() {
                //
                //   })
                // },
              ),

              SizedBox(height: 10,),


              // DropdownSearch<String>(
              //   popupProps: PopupProps.menu(
              //     showSelectedItems: true,
              //     showSearchBox: true,
              //     disabledItemFn: (String s) => s.startsWith('I'),
              //   ),
              //   items: [users[0], users[1], users[2], users[3]],
              //   dropdownDecoratorProps: DropDownDecoratorProps(
              //     dropdownSearchDecoration: InputDecoration(
              //       labelText: "Select/search sender",
              //       labelStyle: bodyTextBlackBigger,
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //
              //       )
              //     ),
              //   ),
              //   onChanged: print,
              //   selectedItem:  users[0],
              // ),





              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount to Send', labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  suffixIcon: DropdownButton<String>(
                    value: selectedSenderCurrency,
                    onChanged: (value) {
                      setState(() {
                        selectedSenderCurrency = value!;
                      });
                    },
                    items: currencies.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                  ),
                ),
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                onChanged: (value) {
                  // Calculate the "They Receive" amount based on the conversion rate
                  double conversionRate = 1.25; // Replace this with the actual conversion rate from API
                  double transactionFee = 2.5; // Replace this with the actual transaction fee from API
                  double amountToSend = double.tryParse(value) ?? 0.0;
                  double theyReceiveAmount = amountToSend * conversionRate;
                  _theyReceiveController.text = NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2).format(theyReceiveAmount);
                  _conversionRateController.text = NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2).format(conversionRate);
                  _transactionFeeController.text = NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2).format(transactionFee);
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'They Receive'),
                      controller: _theyReceiveController,
                      enabled: false,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedBeneficiaryCurrency,
                      onChanged: (value) {
                        setState(() {
                          selectedBeneficiaryCurrency = value!;
                        });
                      },
                      items: currencies.map((currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              // Container displaying the conversion rate and transaction fee
              Container(
                width: size.width,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Conversion Rate: ${_conversionRateController.text}', style: bodyTextBlackBigger),
                    Text('Transaction Fee: ${_transactionFeeController.text}', style: bodyTextBlackBigger),
                  ],
                ),
              ),
              SizedBox(height: 5,),





              TextFormField(
                controller: _purposeOfPaymentController,
                decoration: InputDecoration(

                    labelText: 'Purpose of Payment',
                    labelStyle: bodyTextBlackBigger,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )
                ),
                style: blueText,
              ),

              SizedBox(height: 8),
              Text("Send to", style: bodyTextBlackBigger),
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
                      child: Text(
                        'Bank',
                        style: selectedSendToOption == sendToOptions[0]
                            ? bodyTextWhite
                            : bodyTextBlacker,
                      ),
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
                      child: Text(
                        'Mobile Money',
                        style: selectedSendToOption == sendToOptions[1]
                            ? bodyTextWhite
                            : bodyTextBlacker,
                      ),
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
                      child: Text(
                        'Pick Up',
                        style: selectedSendToOption == sendToOptions[2]
                            ? bodyTextWhite
                            : bodyTextBlacker,
                      ),
                    ),
                  ),
                ],
              ),

              if (selectedSendToOption == sendToOptions[0]) // Bank selected, show bank name and account number fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
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
                          labelText: 'Bank name', labelStyle: bodyTextBlackBigger,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),

                          )
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _accountNumberController,
                      decoration: InputDecoration(
                          labelText: 'Account Number', labelStyle: bodyTextBlackBigger,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          )
                      ),
                      style: blueText,
                    ),
                  ],
                ),



              if (selectedSendToOption == sendToOptions[1]) // Pickup selected, show pickup location field
                TextFormField(

                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                      labelText: 'Phone number', labelStyle: bodyTextBlackBigger,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  style: blueText,
                ),

              if (selectedSendToOption == sendToOptions[2]) // Pickup selected, show pickup location field
                TextFormField(

                  controller: _pickupLocationController,
                  decoration: InputDecoration(
                      labelText: 'Pickup Location', labelStyle: bodyTextBlackBigger,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
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
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getClientsListItems() {
    // Replace this with your actual list of clients
    List<String> clients = ['Client 1', 'Client 2', 'Client 3'];

    return clients.map((client) {
      return DropdownMenuItem<String>(
        value: client,
        child: Text(client, style: blueText,),
      );
    }).toList();
  }
}




