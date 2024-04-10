import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/models/user.dart';
import 'package:quizletapp/services/firebase.dart';
import 'package:quizletapp/services/firebase_auth.dart';

class TopicService {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FirebaseService firebaseService = FirebaseService();

  Future<List<TopicModel>> getMyListTopic() async {
    try {
      if (firebaseAuthService.isUserLoggedIn()) {
        var user = await firebaseAuthService.getCurrentUser();
        var listTopic = await firebaseService.getDocumentsByField('topics', 'userId', user?.uid);
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

  //Thêm một topic mới vào firestore
  Future<void> addTopic(TopicModel topic) async {
    try {
      // Chuyển đổi TopicModel thành một Map<String, dynamic>
      Map<String, dynamic> topicData = topic.toMap();
      await firebaseService.addDocument('topics', topicData);
    } catch (error) {
      print('Error adding topic document: $error');
      throw error;
    }
  }
}
