class User {
  String userName;
  String password;
  String phoneNumber;
  String userId;
  String photoUrl;

  User(
      {this.userName,
      this.password,
      this.phoneNumber,
      this.userId,
      this.photoUrl});

  factory User.fromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] ?? '',
      userName: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      photoUrl: json['photoUrl'] ?? '');

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is User &&
        this.userName == userName &&
        this.password == password &&
        this.phoneNumber == phoneNumber &&
        this.userId == userId &&
        this.photoUrl == photoUrl;
  }

  @override
  int get hashCode => super.hashCode;
}
