import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentDetailsBottomSheet extends StatelessWidget {
  final String amount;
  final String youSend;
  final String theyReceive;
  final String userName;
  final String deliveryMode;
  final String accountNumber;
  final String senderCurrency;
  final String beneficiaryCurrency;


  const PaymentDetailsBottomSheet({
    required this.amount,
    required this.youSend,
    required this.theyReceive,
    required this.userName,
    required this.deliveryMode,
    required this.accountNumber,
    required this.senderCurrency,
    required this.beneficiaryCurrency,
  });

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
                Text(
                  amount,
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
                    youSend,
                    style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700,),
                  ),
                  Text(
                    senderCurrency,
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
                  Text(
                    theyReceive,
                    style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700,),
                  ),
                  Text(
                    beneficiaryCurrency,
                    style: GoogleFonts.inter(fontSize: 11.0, fontWeight: FontWeight.w400,),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 32.0),
          buildRow(Icons.person,'Name', userName),
          SizedBox(height: 10,),
          buildRow(Icons.send_outlined,'Delivery Mode', deliveryMode),
          SizedBox(height: 10,),
          buildRow(Icons.warehouse_outlined,'Account Number', accountNumber),
          SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () {
              // Perform confirmation action
              Navigator.pop(context); // Close the bottom sheet
            },
            child: Text('Confirm', style: whiteText,),
            style: ButtonStyleConstants.primaryButtonStyle,
          ),
        ],
      ),
    );
  }

  Widget buildRow(IconData labelIcon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(labelIcon, color: Colors.grey, size: 20,),
            SizedBox(width: 10,),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 15.0, fontWeight: FontWeight.w400,),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 15.0, fontWeight: FontWeight.w400,),
        ),
      ],
    );
  }
}