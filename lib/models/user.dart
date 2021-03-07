enum UserRoles { student, mentor }

class AppUser {
  String uUID;
  int balance;
  /**
   * the role could be student or mentor
   */
  String role;
  List<String> categories;
  String bio;
  String firstName;
  String lastName;
  String avatar;

  AppUser(
      {this.uUID,
      this.balance,
      this.role,
      this.categories,
      this.bio,
      this.firstName,
      this.lastName,
      this.avatar});

  AppUser.fromJson(Map<String, dynamic> json) {
    uUID = json['UUID'];
    balance = json['balance'];
    role = json['role'];
    categories = json['categories'].cast<String>();
    bio = json['bio'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UUID'] = this.uUID;
    data['balance'] = this.balance;
    data['role'] = this.role;
    data['categories'] = this.categories;
    data['bio'] = this.bio;
    data['avatar'] = this.avatar;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}
