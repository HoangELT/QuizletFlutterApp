import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/models/user.dart';
import 'package:quizletapp/services/firebase.dart';
import 'package:quizletapp/services/firebase_auth.dart';

class TopicService {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FirebaseService firebaseService = FirebaseService();

  Future<List<TopicModel>> getTopicsWithUsers() async {
    List<TopicModel> topics = [];

    try {
      // Lấy danh sách topic từ Firestore
      var listTopic = await firebaseService.getDocuments('topics');

      for (var topicMap in listTopic) {
        print(topicMap['userId']);
        UserModel? user =
            await firebaseAuthService.getUserByUid(topicMap['userId']);
        print('Danh sách user');
        print(user);

        TopicModel topic = TopicModel.fromMap(topicMap);
        topic.username = user?.username ?? ''; // Gán username từ dữ liệu user
        topics.add(topic);
      }
    } catch (e) {}

    return topics;
  }

  Future<List<TopicModel>> getListTopicOfCurrentUser() async {
    try {
      if (firebaseAuthService.isUserLoggedIn()) {
        var user = await firebaseAuthService.getCurrentUser();
        var listTopic = await firebaseService.getDocumentsByField(
            'topics', 'userId', user?.uid);
        List<Map<String, dynamic>> listResult = listTopic
            .map((e) => {
                  ...e,
                  ...{
                    'username': user?.displayName ?? '',
                  },
                })
            .toList();
        return TopicModel.fromListMap(listResult);
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
  Future<void> addTopic(TopicModel newTopic) async {
    try {
      // Chuyển đổi TopicModel thành một Map<String, dynamic>
      Map<String, dynamic> topicData = newTopic.toMap();
      await firebaseService.addDocument('topics', topicData);
    } catch (error) {
      print('Error adding topic document: $error');
      throw error;
    }
  }
}
