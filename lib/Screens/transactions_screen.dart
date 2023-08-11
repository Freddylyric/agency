import 'package:agency_app/Screens/single_transaction_details.dart';
import 'package:agency_app/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/transaction_record_model.dart';
import 'package:agency_app/config.dart' as config;
import 'package:google_fonts/google_fonts.dart';

import 'navigation.dart';

class TransactionsScreen extends StatefulWidget {
  final accessToken;

  const TransactionsScreen({Key? key, required this.accessToken}) : super(key: key);
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<List<TransactionRecord>> _transactionsFuture;
  late List<TransactionRecord> _allTransactions;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _transactionsFuture = fetchTransactions();
  }






  Future<List<TransactionRecord>> fetchTransactions() async {
    final String apiUrl = config.transactionsAPI;

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
          final List<dynamic> transactionsData = responseData['data']['data'];

          _allTransactions = transactionsData.map((transactionData) => TransactionRecord.fromJson(transactionData)).toList();
          return _allTransactions;

        } else {
          throw Exception('Failed to fetch transactions: ${responseData['statusDescription']}');
        }
      } else {
        throw Exception('Failed to fetch transactions: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch transactions: $error');
    }
  }


  List<TransactionRecord> _filteredTransactions() {
    if (searchQuery.isEmpty) {
      return _allTransactions;
    } else {
      return _allTransactions.where((transaction) =>
          transaction.beneficiaryName!.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>NavPage(profileInfo: null, accessToken: null,)))
        ),
        title: Text('Transactions', style: bodyTextBlackBigger),
        centerTitle: true,
      ),
      body:



      Column(
        children: [


          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by Beneficiary Name',
                labelStyle: bodyTextBlack,
                border:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),

                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                    });
                  },
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<TransactionRecord>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  final transactions = _filteredTransactions();
                  if (transactions.isEmpty){
                    return Center(
                      child: Text('No transactions found'),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> SingleTransactionDetails(transactionDetails: transaction)));
                        },
                        child: ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                              if (transaction.status == '1')
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
                              if (transaction.status == '2')
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
                                  ),
                                ),
                            ],
                          ),
                          title: Text(transaction!.beneficiaryName.toString(), style: GoogleFonts.inter( fontSize: 15, fontWeight: FontWeight.w600)),
                          subtitle: Text(transaction!.createdAt.toString(), style: GoogleFonts.inter( fontSize: 12, fontWeight: FontWeight.w400)),
                          trailing: Text(
                            '${transaction.currencyReceive} ${formatCurrency(transaction.amount)}',
                              style: GoogleFonts.inter( fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No transactions found.'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatCurrency(double amount) {
    // Add your currency formatting logic here
    return amount.toStringAsFixed(2);
  }
}
