class UserModel {
  String userId;
  String username;
  String email;

  UserModel(this.userId, this.email, this.username);
  // Phương thức tạo danh sách các đối tượng từ danh sách Map
  static List<UserModel> fromListMap(List<Map<String, dynamic>> listMap) {
    return listMap.map((map) => UserModel.fromMap(map)).toList();
  }

  // Phương thức tạo đối tượng từ một Map
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      map['uid'],
      map['email'],
      map['displayName'],
    );
  }

  static String createUsernameFormEmail(String email) {
    return email.split('@')[0];
  }
}
