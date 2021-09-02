class UserModel {
  String id;
  String name;
  String username;
  String password;
  String phoneNumber;
  String chooseType;
  String nameStore;
  String profile;
  String qRCode;
  String token;

  UserModel(
      {this.id,
      this.name,
      this.username,
      this.password,
      this.phoneNumber,
      this.chooseType,
      this.nameStore,
      this.profile,
      this.qRCode,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
    phoneNumber = json['phone_number'];
    chooseType = json['chooseType'];
    nameStore = json['name_store'];
    profile = json['profile'];
    qRCode = json['QRCode'];
    token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['password'] = this.password;
    data['phone_number'] = this.phoneNumber;
    data['chooseType'] = this.chooseType;
    data['name_store'] = this.nameStore;
    data['profile'] = this.profile;
    data['QRCode'] = this.qRCode;
    data['Token'] = this.token;
    return data;
  }
}
