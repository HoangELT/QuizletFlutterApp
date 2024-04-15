import 'package:quizletapp/models/user.dart';
import 'package:quizletapp/services/firebase.dart';

class UserService {
  FirebaseService firebaseService = FirebaseService();

  // Phương thức để lấy thông tin người dùng bằng UID
  Future<UserModel?> getUserByUid(String uid) async {
    try {
      var findUser = await firebaseService.getDocumentsByField('users', 'userId', uid);
      if (findUser.isNotEmpty) {
        return UserModel.fromMap(findUser.first);
      }
      return null;
    } catch (error) {
      // Xử lý lỗi nếu có
      print('Error getting user by UID: $error');
      return null;
    }
  }
}