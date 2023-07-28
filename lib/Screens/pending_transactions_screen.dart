import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:intl/intl.dart';

class PendingTransactionsScreen extends StatelessWidget {
  final List<dynamic> pendingTransactions;

  PendingTransactionsScreen({required this.pendingTransactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),//IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        backgroundColor:  Color(0xFF00284A),
        title: Text('Pending Approvals', style: whiteText,),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: pendingTransactions.length,
        itemBuilder: (context, index) {
          var transaction = pendingTransactions[index];
          // Create a widget to display each pending transaction
          return ListTile(
            leading: Stack(
                children:[
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      // child: Center(
                      //   child: Icon(
                      //     Icons.check,
                      //     color: Colors.white,
                      //     size: 15,
                      //   ),
                      // ),
                    ),
                  ),

                ]
            ),
            title: Text(transaction['beneficiaryName'], style: bodyTextBlackBigger,),
            subtitle: Text(transaction['created_at'], style: bodyTextBlack,),
            trailing: Text(
              '${transaction['currencyReceive']} ${formatCurrency(double.tryParse(transaction['amount']) ?? 0.0)}',
              style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700),
            ),

          );
        },
      ),
    );
  }




  String formatCurrency(double amount) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '', //
      decimalDigits: 2,
    );
    return currencyFormat.format(amount);
  }
}
