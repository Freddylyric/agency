import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agency_app/Utils/utils.dart';

class PendingTransactionsScreen extends StatelessWidget {
  final List<dynamic> pendingTransactions;

  PendingTransactionsScreen({required this.pendingTransactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Transactions'),
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
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),

                ]
            ),
            title: Text(transaction['beneficiaryName'], style: bodyTextBlackBigger,),
            subtitle: Text(transaction['created_at'], style: bodyTextBlack,),
            trailing: Text('${transaction['currencyReceive']}${transaction['amount']} ', style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w700,),),
          );
        },
      ),
    );
  }
}
