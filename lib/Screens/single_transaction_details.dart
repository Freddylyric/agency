import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Utils/utils.dart';
import 'package:agency_app/models/transaction_record_model.dart';



class SingleTransactionDetails extends StatefulWidget {
  final transactionDetails;

  const SingleTransactionDetails({super.key, required this.transactionDetails});

  @override
  State<SingleTransactionDetails> createState() => _SingleTransactionDetailsState();
}

class _SingleTransactionDetailsState extends State<SingleTransactionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
            //height: size.height * 0.35,
            height: 270,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.2),
            child: Column(children: [
              SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
                SizedBox(width: 5),
                Text(
                  'Hello there,',
                  style: bodyTextWhite,
                ),
              ]),

              // ACOUNT BALANCE AREA

              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(
                  height: 10,
                ),
                Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green, size: 50),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${widget.transactionDetails.currencyFrom} ${formatCurrency(widget.transactionDetails.amount)}',
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.green),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Received ${widget.transactionDetails.currencyReceive} ${formatCurrency(widget.transactionDetails.amount)}',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "Commission:",
                    style: bodyTextWhite,
                  ),
                  TextSpan(
                    text: ' ',
                    style: bodyTextWhite,
                  )
                ]))
              ])
            ])),
        SizedBox(height: 20),
        Container(
            //height: size.height * 0.35,
            height: 270,
            width: double.infinity,
            child: Column(children: [
              // buildRows(widget.transactionDetails!),
            ]))
      ]),
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '');
    return formatter.format(amount);
  }


  // Widget buildRows(TransactionRecord transactionRecord) {
  //   List<Widget> rows = [];
  //
  //   // Common rows for all delivery modes
  //   rows.add(buildRow(Icons.person, 'Name', transactionRecord.beneficiaryName));
  //   rows.add(SizedBox(height: 10));
  //   rows.add(buildRow(Icons.send_outlined, 'Delivery Mode', transactionRecord.deliveryMode));
  //
  //   // Rows based on the delivery mode
  //   if (transactionRecord.transactionType == 'Bank') {
  //     rows.add(SizedBox(height: 10));
  //     rows.add(buildRow(Icons.warehouse_outlined, 'Account Number', transactionRecord.bankAccount));
  //   } else if (transactionRecord.transactionType  == 'Mobile Money') {
  //     rows.add(SizedBox(height: 10));
  //     rows.add(buildRow(Icons.phone, 'Phone Number', transactionRecord.beneficiaryPhoneNumber));
  //   } else if (transactionRecord.transactionType  == 'Pick Up') {
  //     rows.add(SizedBox(height: 10));
  //     rows.add(buildRow(Icons.location_on_outlined, 'Location', transactionRecord.address));
  //   }
  //
  //   return Column(
  //     children: rows,
  //   );
  // }


  Widget buildRow(IconData labelIcon, String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              labelIcon,
              color: Colors.grey,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Text(
          value!,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
