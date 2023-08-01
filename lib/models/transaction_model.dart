class TransactionRecord {
  String senderProfileId;
  String senderName;
  String senderPhoneNumber;
  String senderCurrency;
  double youSend;

  String beneficiaryProfileId;
  String beneficiaryName;
  String beneficiaryPhoneNumber;
  String beneficiaryCurrency;
  double theyReceive;


  double amount;
  String senderCountryId;
  String beneficiaryCountryId;

  String deliveryMode;
  String? bankId;
  String? bankAccount;
  String? address;


  TransactionRecord({
    required this.senderProfileId,
    required this.senderName,
    required this.senderPhoneNumber,
    required this.beneficiaryProfileId,
    required this.beneficiaryName,
    required this.beneficiaryPhoneNumber,
    required this.amount,
    required this.senderCountryId,
    required this.beneficiaryCountryId,
    required this.deliveryMode,
    required this.youSend,
    required this.theyReceive,
    required this.senderCurrency,
    required this.beneficiaryCurrency,
    this.bankId,
    this.address,
    this.bankAccount

  });
}
