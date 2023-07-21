class Country {
  final String countryId;
  final String countryName;
  final String currency;
  final String isBaseCurrency;
  // final String isoCode;
  // final String status;
  // final String mobilePrefix;
  // final String countryName;

  Country ({
    required this.countryId,
    required this.countryName,
    required this.currency,
    required this.isBaseCurrency,
    // required this.isoCode,
    // required this.status,
    // required this.mobilePrefix,
    // required this.countryName,
  });

  factory Country .fromJson(Map<String, dynamic> json) {
    return Country(
      countryId: json['country_id'],
      countryName: json['country_name'],
      currency: json['currency'],
      isBaseCurrency: json['isBaseCurrency'],
      // email: json['isoCode'],
      // gender: json['status'],
      // isoCode: json['mobilePrefix'],
      // countryName: json['country_name'],
    );
  }
}
