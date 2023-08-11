import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/transaction_record_model.dart';
import '../models/user_model.dart';

class ClientDetailsScreen extends StatefulWidget {
  // Pass the client details as arguments to the constructor

  final User user;
  final List<TransactionRecord> transactions;

  ClientDetailsScreen({super.key, required this.user, required this.transactions});

  @override
  _ClientDetailsScreenState createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  // Variable to track the currently selected tab (info or transactions)
  String _selectedTab = 'info';
  late List<TransactionRecord> userTransactions;


  @override
  void initState() {
    super.initState();
    // Filter transactions for the specific user
    userTransactions = widget.transactions.where((transaction) =>
    transaction.senderName == '${widget.user.firstName} ${widget.user.middleName} ${widget.user.lastName}'
    ).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Color(0XFFF6F7F9) ,
        backgroundColor: Colors.grey.withOpacity(0.2),
        title: Text('Client Details', style: bodyTextBlacker,),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black,),
            onPressed: () {
              // Implement the menu functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric( horizontal: 16),
              height: 250,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${widget.user.firstName}${widget.user.middleName} ${widget.user.lastName}',
                        style: GoogleFonts.inter( fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xff002749)),
                      ),
                      Text(
                        widget.user.kycType?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 'info';
                          });
                        },
                        child:
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 3, // This can be the space you need between text and underline
                          ),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: _selectedTab == 'info' ? Color(0xff002749): Colors.grey.withOpacity(0.2),
                                width: 3.0, // This would be the width of the underline
                              ))
                          ),
                          child: Text('Info', style: TextStyle(color: _selectedTab == 'info' ? Color(0xff002749) : Colors.grey,
                              fontSize: 16,
                      ), ),

                        ),
                      ),
                      SizedBox(width: 20,),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 'transactions';
                          });
                        },
                        child:
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 3, // This can be the space you need between text and underline
                          ),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: _selectedTab == 'transactions' ? Color(0xff002749): Colors.grey.withOpacity(0.2),
                                width: 3.0, // This would be the width of the underline
                              ))
                          ),
                          child: Text(
                            'Transactions',
                            style: TextStyle(
                              color: _selectedTab == 'transactions' ? Color(0xff002749) : Colors.grey,
                              fontSize: 16,

                            ),
                          ),
                        ),




                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_selectedTab == 'info')
              Container(
                height: 300,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ListView(
                  children: [
                    
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(

                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(widget.user.seonScore?? ''),
                              ),
                              SizedBox(width: 5,),
                              Text("Seon Score", style: bodyTextBlack,),
                            ]
                          ),

                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(widget.user.kycStatus?? 'Not approved'),
                              ),
                              SizedBox(width: 5,),
                              Text("Verrif Status", style: bodyTextBlack,),
                            ],
                          )
                        ]
                      ),


                    ),
                    // Implement the details info here based on your data
                    Divider(),
                    InfoRow(label: 'Phone number', value: widget.user.msisdn?? ''),
                    SizedBox(height: 10,),
                    InfoRow(label: 'Email', value: widget.user.emailAddress?? ''),
                    Divider(),
                    InfoRow(label: 'Account Type', value: 'Bank'),
                    SizedBox(height: 10,),
                    InfoRow(label: 'Account', value: 'Kcb'),
                    SizedBox(height: 10,),
                    InfoRow(label: 'Account number', value: 'value'),
                  ],
                ),
              ),
            if (_selectedTab == 'transactions')
              Container(
                height: 300,
                width: double.infinity,
                child: ListView(
                  children: userTransactions.map((transaction) =>
                      TransactionListItem(title: transaction.transID, amount: transaction.amount.toString())
                  ).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom Widget for Info Row
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter( fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff48494a)),),
        Text(value, style: GoogleFonts.inter( fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff002749)),),
      ],
    );
  }
}

// Custom Widget for Transaction List Item
class TransactionListItem extends StatelessWidget {
  final String title;
  final String amount;

  const TransactionListItem({
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(amount),
    );
  }
}
