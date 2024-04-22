import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/models/user.dart';
import 'package:quizletapp/services/firebase.dart';
import 'package:quizletapp/services/firebase_auth.dart';
import 'package:quizletapp/services/models_services/user_service.dart';

class TopicService {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FirebaseService firebaseService = FirebaseService();
  UserService userService = UserService();

  Future<TopicModel?> getTopicById(String topicId) async {
    try {
      var getTopicById = await firebaseService.getDocument('topics', topicId);
      return TopicModel.fromMap(getTopicById);
    } catch (e) {
      print('Topic service error: $e');
    }
    return null;
  }

  Future<List<TopicModel>> getTopicsWithUsers() async {
    List<TopicModel> topics = [];

    try {
      // Lấy danh sách topic từ Firestore
      var listTopic = await firebaseService.getDocuments('topics');

      for (var topicMap in listTopic) {
        UserModel? user = await userService.getUserByUid(topicMap['userId']);

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
        var user = firebaseAuthService.getCurrentUser();
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
        return sortTopicsByDateDescending(TopicModel.fromListMap(listResult));
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
  Future<String> addTopic(TopicModel newTopic) async {
    try {
      var id = await firebaseService.addDocument('topics', newTopic.toMap());
      return id;
    } catch (error) {
      print('Error adding topic document: $error');
    }
    return '';
  }

  static List<TopicModel> sortTopicsByDate(List<TopicModel> topics) {
    topics.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
    return topics;
  }

  static List<TopicModel> sortTopicsByDateDescending(List<TopicModel> topics) {
    topics.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    return topics;
  }

  static TopicModel sortTopicByABC(TopicModel topic) {
    topic.listCard.sort((a, b) => a.term.compareTo(b.term));
    return topic;
  }

  List<TopicModel> getTopicsToday(List<TopicModel> listTopicOfCurrentUser) {
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
    DateTime endOfToday =
        DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    List<TopicModel> topicsToday = [];

    listTopicOfCurrentUser.forEach((topicModel) {
      if (topicModel.dateCreated.isAfter(startOfToday) &&
          topicModel.dateCreated.isBefore(endOfToday)) {
        topicsToday.add(topicModel);
      }
    });

    return sortTopicsByDateDescending(topicsToday);
  }

  void printListTopics(List<TopicModel> listTopics) {
    print('List topics:');
    for (var i in listTopics) {
      print(i.toString());
    }
  }
}
