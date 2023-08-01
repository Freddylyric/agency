class TransactionRecord {
  final String transID;
  final String? receipt;
  final String clientName;
  final String agentName;
  final String approvalLevel;
  final String? msisdn;
  final String? network;
  final String? currentApprovalLevel;
  final String? beneficiaryProfileId;
  final String? beneficiaryMsisdn;
  final String? uniqueReferenceId;
  final String? transactionType;
  final String status;
  final double amount;
  final String currencyFrom;
  final String currencyReceive;
  final String senderName;
  final String beneficiaryName;
  final String source;
  final String extrac;
  final String createdAt;
  final String? totalTransactions;

  TransactionRecord({
    required this.transID,
    this.receipt,
    required this.clientName,
    required this.agentName,
    required this.approvalLevel,
    required this.msisdn,
     this.network,
    required this.currentApprovalLevel,
     this.beneficiaryProfileId,
     this.beneficiaryMsisdn,
    this.uniqueReferenceId,
     this.transactionType,
    required this.status,
    required this.amount,
    required this.currencyFrom,
    required this.currencyReceive,
    required this.senderName,
    required this.beneficiaryName,
     required this.source,
     required this.extrac,
    required this.createdAt,
     this.totalTransactions,
  });

  factory TransactionRecord.fromJson(Map<String, dynamic> json) {
    return TransactionRecord(
      transID: json['transID'],
      receipt: json['receipt'],
      clientName: json['client_name'],
      agentName: json['agentName'],
      approvalLevel: json['approval_level'],
      msisdn: json['msisdn'],
      network: json['network'],
      currentApprovalLevel: json['current_approval_level'],
      beneficiaryProfileId: json['beneficiary_profileId'],
      beneficiaryMsisdn: json['beneficiaryMsisdn'],
      uniqueReferenceId: json['unique_referenceId'],
      transactionType: json['transaction_type'],
      status: json['status'],
      amount: double.parse(json['amount']),
      currencyFrom: json['currencyFrom'],
      currencyReceive: json['currencyReceive'],
      senderName: json['senderName'],
      beneficiaryName: json['beneficiaryName'],
      source: json['source'],
      extrac: json['extrac'],
      createdAt: json['created_at'],
      totalTransactions: json['totalTransactions'],
    );
  }
}
