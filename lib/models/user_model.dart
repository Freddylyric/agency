class User {


  final String profileId;
  final String? msisdn;
  final String? seonPass;
  final String? seonScore;
  final String? firstName;
  final String? emailAddress;
  final String? isoCode;
  final String? isoCode2;
  final String? countryId;
  final String? countryName;
  final String? countryFlag;
  final String? lastName;
  final String? middleName;
  final String? gender;
  final String? kycUrl;
  final String? kycStatus;
  final String? kycInfo;
  final String? expirationDate;
  final String? kycType;
  final String? created;
  final String? total;


  User( {


    required this.profileId,
     this.msisdn,
     this.seonPass,
    this.seonScore,
     this.firstName,
    this.emailAddress,
     this.isoCode,
     this.isoCode2,
     this.countryId,
     this.countryName,
     this.countryFlag,
     this.lastName,
     this.middleName,
     this.gender,
    this.kycUrl,
    this.kycStatus,
    this.kycInfo,
    this.expirationDate,
    this.kycType,
     this.created,
     this.total,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(


      profileId: json['profile_id'],
      msisdn: json['msisdn'],
      seonPass: json['seon_pass'],
      seonScore: json['seon_score'],
      firstName: json['first_name'],
      emailAddress: json['email_address'],
      isoCode: json['isoCode'],
      isoCode2: json['isoCode2'],
      countryId: json['countryId'],
      countryName: json['country_name'],
      countryFlag: json['country_flag'],
      lastName: json['last_name'],
      middleName: json['middle_name'],
      gender: json['gender'],
      kycUrl: json['kyc_url'],
      kycStatus: json['kyc_status'],
      kycInfo: json['kyc_info'],
      expirationDate: json['expiration_date'],
      kycType: json['kyc_type'],
      created: json['created'],
      total: json['total'],
    );
  }
}
