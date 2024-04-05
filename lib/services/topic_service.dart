import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/services/firebase.dart';
import 'package:quizletapp/services/firebase_auth.dart';

class TopicService {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FirebaseService firebaseService = FirebaseService();

  Future<List<TopicModel>> getMyListTopic() async {
    try {
      if (firebaseAuthService.isUserLoggedIn()) {
        var listTopic = await firebaseService.getDocuments('topics');
        return TopicModel.fromListMap(listTopic);
      } else {
        // Nếu người dùng chưa đăng nhập, trả về danh sách trống
        return [];
      }
    } catch (e) {
      print('Lỗi lấy topics: ${e}');
      // Trong trường hợp lỗi, cũng trả về danh sách trống
      return [];
    }
  }
}
