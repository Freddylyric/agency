import 'package:agency_app/Screens/home_screen.dart';
import 'package:agency_app/Screens/navigation.dart';
import 'package:agency_app/Screens/payment_details_bottomsheet.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../models/countries_model.dart';
import '../models/user_model.dart';
import 'add_client_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agency_app/config.dart' as config;


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
  String defaultSenderCurrency = 'USD';
  String defaultBeneficiaryCurrency = 'USD';
  late double totalAmount = 0;




  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _pickupLocationController = TextEditingController();
  final TextEditingController _purposeOfPaymentController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _theyReceiveController = TextEditingController();
  final TextEditingController _conversionRateController = TextEditingController();
  final TextEditingController _transactionFeeController = TextEditingController();

  //List<String> countries = ['Kenya', 'Country 2', 'Country 3', 'Country 4'];
  List<String> banks = ['Kenya Commercial Bank', 'bank 2', 'bank 3', 'bank 4'];



  List<User> users = [];
  List<Country> countries = [];
  List<Country> baseCurrencies = [];

  String selectedSender = '';
  String selectedBeneficiary = '';
  late String selectedSenderCountryId = '';
  late String selectedBeneficiaryCountryId = '';
  late String selectedSenderCurrency ;
  late String selectedBeneficiaryCurrency ;

  List<String> sendToOptions = ['Bank', 'Mobile Money', 'Pick Up'];




  @override
  void initState() {
    super.initState();

    fetchRequireddata();

    selectedSenderCurrency = defaultSenderCurrency;
    selectedBeneficiaryCurrency = defaultBeneficiaryCurrency;


  }

  //Functions


  void fetchRequireddata() {
    // Fetch user data when the screen is initialized
    fetchUsers().then((fetchedUsers) {
      setState(() {
        users = fetchedUsers;
      });
    }).catchError((error) {
      // Handle error if fetching user data fails
      print('Error fetching users: $error');
    });


    // Fetch user data when the screen is initialized
    fetchCountries().then((fetchedCountries) {
      setState(() {
        countries = fetchedCountries;
        baseCurrencies = fetchedCountries.where((country) => country.isBaseCurrency == '1').toList();

      });
    }).catchError((error) {
      // Handle error if fetching user data fails
      print('Error fetching users: $error');
    });



  }

  // Country? findCountryByCurrency(String currency) {
  //   return baseCurrencies.firstWhere((country) => country.currency == currency, orElse: () => null);
  // }



  // API FUNCTIONS


  Future<List<User>> fetchUsers() async {
    final String apiUrl = config.customersAPI;

    final Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
      'X-Token-Key': widget.accessToken,
    };

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['code'] == 'Success') {
          final List<dynamic> usersData = responseData['data']['data'];

          return usersData.map((userData) => User.fromJson(userData)).toList();
        } else {
          throw Exception('Failed to fetch users: ${responseData['statusDescription']}');
        }
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch users: $error');
    }
  }



  Future<List<Country>> fetchCountries() async {
    final String apiUrl = config.countriesAPI;
    final Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,

    };

    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      print(responseData);
      if (responseData['code'] == 'Success') {
        List<Country> countries = [];
        for (var countryData in responseData['data']['data']) {
          countries.add(Country.fromJson(countryData));

          // filter the country list to have a list of basecurrencies, where the isBaseCurrency == 1
          //var baseCountries = countries.where((country) => country.isBaseCurrency == 1).toList();

        }
        // filter the country list to have a list of basecurrencies, where the isBaseCurrency == 1
        // baseCountries = countries.where((country) => country.isBaseCurrency == 1).toList();
        // print(baseCountries);

        return countries;
      } else {
        throw Exception('API request failed');
      }
    } else {
      throw Exception('API request failed');
    }
  }


  Future<double> fetchConversionRate(String baseCountryId, String beneficiaryCountryId) async {
    const String apiUrl = config.conversionRateAPI;
    final Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
    };

    final Map<String, String> queryParams = {
      'baseCountryID': baseCountryId,
    };


    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: headers,);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['code'] == 'Success') {
        List<dynamic> data = responseData['data']['data'];
        for (var rateData in data) {
          if (rateData['countryID'] == beneficiaryCountryId) {
            return double.parse(rateData['rate']);
          }
        }
        throw Exception('Conversion rate not found for beneficiary country');
      } else {
        throw Exception('API request failed');
      }
    } else {
      throw Exception('API request failed');
    }
  }



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
                    .map((user) => SearchFieldListItem('${user.firstName} ${user.lastName}:    ${user.msisdn}'))
                    .toList(),
                suggestionState: Suggestion.expand,
                textInputAction: TextInputAction.next,
                hint: 'Select/Search Sender',
                searchStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.8),
                ),
                validator: (x) {
                  if (!users.any((user) => '${user.firstName} ${user.lastName}' == x) ||
                      x!.isEmpty) {
                    return 'Please enter a valid User';
                  }
                  return null;
                },
                searchInputDecoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Add a Client', textAlign: TextAlign.center),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Close',
                                    style: whiteText,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AddClientScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Okay',
                                    style: whiteText,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.add_circle_outline, color: Colors.blue),
                  ),
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

                // onSuggestionTap: (x) {
                //   setState(() {
                //     selectedSender = x.toString();
                //     print(selectedSender);
                //   });
                // },
                // onSuggestionTap: (SearchFieldListItem){
                //   setState(() {
                //     selectedSender = SearchFieldListItem.toString();
                //   })
                // },


              ),
              SizedBox(height: 10,),


              SearchField(
                suggestions: users
                    .map((user) => SearchFieldListItem('${user.firstName} ${user.lastName}: ${user.msisdn}'))
                    .toList(),
                suggestionState: Suggestion.expand,
                textInputAction: TextInputAction.next,
                hint: 'Select/Search beneficiary',
                searchStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.8),
                ),
                validator: (x) {
                  if (!users.any((user) => '${user.firstName} ${user.lastName}' == x) ||
                      x!.isEmpty) {
                    return 'Please enter a valid User';
                  }
                  return null;
                },
                searchInputDecoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Add a Client', textAlign: TextAlign.center),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Close',
                                    style: whiteText,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AddClientScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Okay',
                                    style: whiteText,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.add_circle_outline, color: Colors.blue),
                  ),
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
                // onSearchTextChanged: (x) {
                //   fetchUsersList(x);
                // },
                onSuggestionTap: (x) {
                  setState(() {
                    selectedBeneficiary = x.toString();
                    print(selectedBeneficiary);
                  });
                },
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
                  labelText: 'You send', labelStyle: bodyTextBlackBigger,
                  suffixIcon: DropdownButton<String>(
                    value: selectedSenderCurrency,
                    onChanged: (value) {
                      setState(() {
                        selectedSenderCurrency = value!;
                        Country selectedCountry = baseCurrencies.firstWhere((country) => country.currency == value);
                        selectedSenderCountryId = selectedCountry.countryId;

                      });
                    },
                    items: buildBaseCurrencyDropdownItems(),
                  ),
                ),
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                onChanged: (value) async {

                  Country selectedSenderCountry = baseCurrencies.firstWhere((country) => country.currency == selectedSenderCurrency);
                  selectedSenderCountryId = selectedSenderCountry.countryId;

                  //set the beneficiary countryId incase defaults
                  Country selectedBeneficiaryCountry = countries.firstWhere((country) => country.currency == selectedBeneficiaryCurrency);
                  selectedBeneficiaryCountryId = selectedBeneficiaryCountry.countryId;

                  // Calculate the "They Receive" amount based on the conversion rate
                  double conversionRate = await fetchConversionRate(
                    selectedSenderCountryId, // Replace with the ID of the base currency country
                    selectedBeneficiaryCountryId, // Replace with the ID of the beneficiary currency country
                  );
                  double transactionFee = 2.5; // Replace this with the actual transaction fee from API
                  double amountToSend = double.tryParse(value) ?? 0.0;
                  double theyReceiveAmount = amountToSend * conversionRate;
                   totalAmount = amountToSend + transactionFee;
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
                      decoration: InputDecoration(labelText: 'They Receive', labelStyle:bodyTextBlackBigger),
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
                          Country selectedCountry = countries.firstWhere((country) => country.currency == value);
                          selectedBeneficiaryCountryId = selectedCountry.countryId;

                        });
                      },
                      items: buildCurrencyDropdownItems(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              // Container displaying the conversion rate and transaction fee
              Container(
                width: size.width,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Conversion Rate: ${_conversionRateController.text}', style: bodyTextBlackBigger),
                    SizedBox(height: 5,),
                    Text('Transaction Fee: ${_transactionFeeController.text}', style: bodyTextBlackBigger),
                  ],
                ),
              ),
              SizedBox(height: 10,),





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
                        amount: totalAmount.toString(),
                        youSend: _amountController.text.toString(),
                        theyReceive: _theyReceiveController.text.toString(),
                        userName: selectedBeneficiary,
                        deliveryMode: 'Bank Account',
                        accountNumber: '1234567890',
                        senderCurrency: selectedSenderCurrency,
                        beneficiaryCurrency: selectedBeneficiaryCurrency,
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

  // List<DropdownMenuItem<String>> _getClientsListItems() {
  //   // Replace this with your actual list of clients
  //   List<String> clients = ['Client 1', 'Client 2', 'Client 3'];
  //
  //   return clients.map((client) {
  //     return DropdownMenuItem<String>(
  //       value: client,
  //       child: Text(client, style: blueText,),
  //     );
  //   }).toList();
  // }



  List<DropdownMenuItem<String>> buildBaseCurrencyDropdownItems() {
    // Sort the baseCurrencies  in alphabetical order
    baseCurrencies.sort((a, b) => a.currency.compareTo(b.currency));

    return baseCurrencies.map((currency) {
      return DropdownMenuItem<String>(
        value: currency.currency,
        child: Text(currency.currency),
      );
    }).toList();
  }


  List<DropdownMenuItem<String>> buildCurrencyDropdownItems() {
    //sort in alphabetical order
    countries.sort((a, b) => a.currency.compareTo(b.currency));
    return countries.map((currency) {
      return DropdownMenuItem<String>(
        value: currency.currency,
        child: Text(currency.currency),
      );
    }).toList();
  }


}




