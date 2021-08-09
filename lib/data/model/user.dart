class User {
	String userName;
	String password;
	String phoneNumber;
	String userId;
	
	User({
		this.userName,
		this.password,
		this.phoneNumber,
		this.userId
	});
	
	@override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is User &&
		this.userName     == userName &&
		this.password     == password &&
    this.phoneNumber  == phoneNumber &&
    this.userId       == userId;
  }
  
  @override
  int get hashCode => super.hashCode;
}