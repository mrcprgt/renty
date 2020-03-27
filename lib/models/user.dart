class User {
  final String id;
  final String fullName;
  final String email;
  final int contactNumber;
  final String address;
  final DateTime birthDate;
  final DateTime accountCreated;

  final bool isVerifiedUser;

  User(
      {this.id,
      this.fullName,
      this.email,
      this.contactNumber,
      this.address,
      this.birthDate,
      this.accountCreated,
      this.isVerifiedUser});

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['full_name'],
        email = data['email'],
        contactNumber = data['contact_number'],
        address = data['address'],
        birthDate = data['birth_date'],
        accountCreated = data['acc_created'].toDate(),
        isVerifiedUser = data['is_verified'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'contact_number': contactNumber,
      'address': address,
      'birth_date': birthDate,
      'acc_created': accountCreated,
      'is_verified': isVerifiedUser
    };
  }
}
