import 'dart:ui';

import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agency_app/config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/transaction_model.dart';

class PaymentDetailsBottomSheet extends StatefulWidget {




  final String accessToken;

  final TransactionRecord? transaction;



  const PaymentDetailsBottomSheet({



    required this.accessToken,
    required this.transaction,

  });

  @override
  State<PaymentDetailsBottomSheet> createState() => _PaymentDetailsBottomSheetState();
}

class _PaymentDetailsBottomSheetState extends State<PaymentDetailsBottomSheet> {



  Future<void> _makeBankPayment() async {
    print(widget.transaction!.senderProfileId);
    print(widget.transaction!.beneficiaryProfileId);
    print(widget.transaction!.amount);
    print(widget.transaction!.senderCountryId);
    print(widget.transaction!.beneficiaryCountryId);
    print(widget.accessToken);


    // API endpoint URL
    final String apiUrl = config.paymentAPI;

    // Request headers
    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
      'X-Token-Key': widget.accessToken,
    };
    //the body
    Map<String, dynamic> paymentBody = {
      "transactionTypeId": 2,
      "senderProfile_id": double.tryParse(widget.transaction!.senderProfileId),
      "receiverProfile_id": double.tryParse(widget.transaction!.beneficiaryProfileId),
      "amount": widget.transaction!.amount,
      "senderCountry_id": double.tryParse(widget.transaction!.senderCountryId),
      "receiverCountry_id": double.tryParse(widget.transaction!.beneficiaryCountryId),
      "bankId":widget.transaction!.bankId,
      "account":widget.transaction!.bankAccount,
      "address":widget.transaction!.address,
      "paymentDescription": "test",
    };

    try {
      // Send the API request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(paymentBody),

      );

      // Parse the response JSON
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check the response status
      if (response.statusCode == 200 && responseData['code'] == 'Success') {
        // show a snackbar to confirm a successful payment
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment initiated has queued for processing'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);

      } else {
        // Failed payment

        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Payment Failed: $errorMessage');
        // show a snackbar with the error details
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment Failed: $errorMessage'),
              backgroundColor: Colors.red,


            )
        );
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error occurred while calling the 3API: $error');
      // show a snackbar with the error details
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred while making the payment: $error'),
            backgroundColor: Colors.red,
          )
      );
      Navigator.pop(context);
    }

  }

  void _makeMobileMoneyPayment() {
    _makePayment();
  }

  Future<void> _makePickUpPayment() async {
    print(widget.transaction!.senderProfileId);
    print(widget.transaction!.beneficiaryProfileId);
    print(widget.transaction!.amount);
    print(widget.transaction!.senderCountryId);
    print(widget.transaction!.beneficiaryCountryId);
    print(widget.accessToken);


    // API endpoint URL
    final String apiUrl = config.paymentAPI;

    // Request headers
    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
      'X-Token-Key': widget.accessToken,
    };
    //the body
    Map<String, dynamic> paymentBody = {
      "transactionTypeId": 2,
      "senderProfile_id": double.tryParse(widget.transaction!.senderProfileId),
      "receiverProfile_id": double.tryParse(widget.transaction!.beneficiaryProfileId),
      "amount": widget.transaction!.amount,
      "senderCountry_id": double.tryParse(widget.transaction!.senderCountryId),
      "receiverCountry_id": double.tryParse(widget.transaction!.beneficiaryCountryId),
      "address":widget.transaction!.address,
      "paymentDescription": "test",
    };

    try {
      // Send the API request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(paymentBody),

      );

      // Parse the response JSON
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check the response status
      if (response.statusCode == 200 && responseData['code'] == 'Success') {
        // show a snackbar to confirm a successful payment
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment initiated has queued for processing'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);

      } else {
        // Failed payment

        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Payment Failed: $errorMessage');
        // show a snackbar with the error details
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment Failed: $errorMessage'),
              backgroundColor: Colors.red,


            )
        );
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error occurred while calling the 3API: $error');
      // show a snackbar with the error details
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred while making the payment: $error'),
            backgroundColor: Colors.red,
          )
      );
      Navigator.pop(context);
    }

  }




  Future<void> _makePayment() async {
    print(widget.transaction!.senderProfileId);
    print(widget.transaction!.beneficiaryProfileId);
    print(widget.transaction!.amount);
    print(widget.transaction!.senderCountryId);
    print(widget.transaction!.beneficiaryCountryId);
    print(widget.accessToken);


    // API endpoint URL
    final String apiUrl = config.paymentAPI;

    // Request headers
    Map<String, String> headers = {
      'X-App-Key': config.appKey,
      'X-Authorization-Key': config.authorizationKey,
      'X-Requested-With': config.requestedWith,
      'Content-Type': config.contentType,
      'X-Token-Key': widget.accessToken,
    };
    //the body
    Map<String, dynamic> paymentBody = {
      "transactionTypeId": 2,
      "senderProfile_id": double.tryParse(widget.transaction!.senderProfileId),
      "receiverProfile_id": double.tryParse(widget.transaction!.beneficiaryProfileId),
      "amount": widget.transaction!.amount,
      "senderCountry_id": double.tryParse(widget.transaction!.senderCountryId),
      "receiverCountry_id": double.tryParse(widget.transaction!.beneficiaryCountryId),
      "paymentDescription": "test",
    };

    try {
      // Send the API request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(paymentBody),

      );

      // Parse the response JSON
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check the response status
      if (response.statusCode == 200 && responseData['code'] == 'Success') {
        // show a snackbar to confirm a successful payment
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment initiated has queued for processing'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);

      } else {
        // Failed payment

        String errorMessage = responseData['statusDescription'] ?? 'Unknown error';
        print('Payment Failed: $errorMessage');
        // show a snackbar with the error details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Failed: $errorMessage'),
            backgroundColor: Colors.red,


          )
        );
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error occurred while calling the 3API: $error');
      // show a snackbar with the error details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred while making the payment: $error'),
          backgroundColor: Colors.red,
        )
      );
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Details',
                style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w400, ),
              ),
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.close))
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
              border:  Border.all(color: Colors.blue, width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'From Wallet',
                  style: GoogleFonts.inter(fontSize: 11.0, fontWeight: FontWeight.w400,),
                ),
                SizedBox(height: 5,),
                Text(
                  NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2).format(widget.transaction!.amount),
                  style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700,),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You Send',
                    style: GoogleFonts.inter(fontSize: 11.0, fontWeight: FontWeight.w400,),
                  ),
                  SizedBox(height: 5,),

                  Text(
                    NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2).format(widget.transaction!.youSend),
                    style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700,),
                  ),
                  Text(
                    widget.transaction!.senderCurrency,
                    style: GoogleFonts.inter(fontSize: 11.0, fontWeight: FontWeight.w400,),
                  ),

                ],
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.blue,

                  child: Icon(Icons.arrow_forward, color: Colors.white,)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'They Receive',
                    style: GoogleFonts.inter(fontSize: 11.0, fontWeight: FontWeight.w400,),
                  ),
                  SizedBox(height: 5,),
                  Text(NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2).format(widget.transaction!.theyReceive),
                    style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700,),
                  ),
                  Text(
                    widget.transaction!.beneficiaryCurrency,
                    style: GoogleFonts.inter(fontSize: 11.0, fontWeight: FontWeight.w400,),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 32.0),


          buildRows(widget.transaction!),

          SizedBox(height: 32.0),





          ElevatedButton(
            onPressed: () {
              if (widget.transaction!.deliveryMode == 'Bank') {
                _makeBankPayment();
              } else if (widget.transaction!.deliveryMode == 'Mobile Money') {
                _makeMobileMoneyPayment();
              } else if (widget.transaction!.deliveryMode == 'Pick Up') {
                _makePickUpPayment();
              } else {
                // Handle the case if the delivery mode is not recognized
              }
            },
            child: Text('Confirm', style: whiteText,),
            style: ButtonStyleConstants.primaryButtonStyle,
          ),
        ],
      ),
    );
  }

  Widget buildRows(TransactionRecord transaction) {
    List<Widget> rows = [];

    // Common rows for all delivery modes
    rows.add(buildRow(Icons.person, 'Name', transaction.beneficiaryName));
    rows.add(SizedBox(height: 10));
    rows.add(buildRow(Icons.send_outlined, 'Delivery Mode', transaction.deliveryMode));

    // Rows based on the delivery mode
    if (transaction.deliveryMode == 'Bank') {
      rows.add(SizedBox(height: 10));
      rows.add(buildRow(Icons.warehouse_outlined, 'Account Number', transaction.bankAccount));
    } else if (transaction.deliveryMode == 'Mobile Money') {
      rows.add(SizedBox(height: 10));
      rows.add(buildRow(Icons.phone, 'Phone Number', transaction.beneficiaryPhoneNumber));
    } else if (transaction.deliveryMode == 'Pick Up') {
      rows.add(SizedBox(height: 10));
      rows.add(buildRow(Icons.location_on_outlined, 'Location', transaction.address));
    }

    return Column(
      children: rows,
    );
  }


  Widget buildRow(IconData labelIcon, String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(labelIcon, color: Colors.grey, size: 20,),
            SizedBox(width: 10,),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 14.0, fontWeight: FontWeight.w400,),
            ),
          ],
        ),
        Text(
          value!,
          style: GoogleFonts.inter(fontSize: 14.0, fontWeight: FontWeight.w400,),
        ),
      ],
    );
  }
}

