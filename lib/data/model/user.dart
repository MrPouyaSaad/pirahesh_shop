class User {
  final String name;
  final String phoneNumber;
  final String address;
  final String postalCode;

  User({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.postalCode,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phoneNumber = json['phoneNumber'],
        address = json['address'],
        postalCode = json['postalCode'];
}
