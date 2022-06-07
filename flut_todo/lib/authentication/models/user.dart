class User {
  String? token;
  String? firstName;
  String? lastName;
  String? email;

  User({this.token, this.firstName, this.lastName, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        token: json['token'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: null);
  }
}
