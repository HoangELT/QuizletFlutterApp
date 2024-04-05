class UserModel {
  String userId;
  String username;
  String identifier;
  DateTime created;

  UserModel(this.userId, this.username, this.identifier, this.created);

  // Phương thức tạo danh sách các đối tượng từ danh sách Map
  static List<UserModel> fromListMap(List<Map<String, dynamic>> listMap) {
    return listMap.map((map) => UserModel.fromMap(map)).toList();
  }

  // Phương thức tạo đối tượng từ một Map
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      map['userId'],
      map['username'],
      map['identifier'],
      DateTime.parse(map['created']),
    );
  }
}
