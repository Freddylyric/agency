class Bank {
  final String bankId;
  final String bankName;
  final String? address;
  final String? countryId;
  final String? status;
  final String? paybill;




  Bank( {
    required this.bankId,
    required this.bankName,
     this.address,
     this.countryId,
    this.status,
     this.paybill,


  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      bankId: json['bank_id'],
      bankName: json['bank'],
      address: json['address'],
      countryId: json['country_id'],
      status: json['status'],
      paybill: json['paybill'],

    );
  }
}
