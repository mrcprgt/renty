class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int contactNumber;
  final String address;
  final DateTime birthDate;

  final bool isVerifiedUser;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.contactNumber,
      this.address,
      this.birthDate,
      this.isVerifiedUser});

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        email = data['email'],
        contactNumber = data['contactNumber'],
        address = data['address'],
        birthDate = data['birthDate'],
        isVerifiedUser = data['isVerifiedUser'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'contactNumber': contactNumber,
      'address': address,
      'birthDate': birthDate,
      'isVerifiedUser': isVerifiedUser
    };
  }
}
