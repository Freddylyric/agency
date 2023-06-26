import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFundsBottomSheet extends StatelessWidget {
  final String wallet;


   AddFundsBottomSheet({

   required this.wallet});

  final _amountController = TextEditingController();
  final _branchController = TextEditingController();
  final _formKey =  GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Funds',
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
                    wallet,
                    style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700,),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount', labelStyle: bodyTextBlackBigger,
                  ),
                ),
                TextFormField(
                  controller: _branchController,
                  decoration: InputDecoration(
                    labelText: 'Branch',labelStyle: bodyTextBlackBigger,
                  ),
                ),

              ]
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                }
                // Perform confirmation action
                // Close the bottom sheet
              },
              child: Text('Send Request', style: whiteText,),
              style: ButtonStyleConstants.primaryButtonStyle,
            ),
            SizedBox(height: 30,),
          ],
        ),
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