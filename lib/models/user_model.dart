class User {
  final String profileId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String msisdn;

  // final String email;
  // final String gender;
  // final String isoCode;
  // final String countryName;

  User( {
    required this.profileId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.msisdn,

    // required this.email,
    // required this.gender,
    // required this.isoCode,
    // required this.countryName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      profileId: json['profile_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      msisdn: json['msisdn'],
      middleName: json['middle_name'],

      // email: json['email_address'],
      // gender: json['gender'],
      // isoCode: json['isoCode'],
      // countryName: json['country_name'],
    );
  }
}
