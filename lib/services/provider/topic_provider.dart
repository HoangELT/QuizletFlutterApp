import 'package:flutter/foundation.dart';
import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/services/models_services/topic_service.dart';

class TopicProvider extends ChangeNotifier {
  List<TopicModel> _listTopicOfCurrentUser = [];

  List<TopicModel> get listTopicOfCurrentUser => _listTopicOfCurrentUser;

  Future<void> reloadListTopic() async {
    try {
      TopicService topicService = TopicService();
      _listTopicOfCurrentUser = await topicService.getListTopicOfCurrentUser();
      notifyListeners();
    } catch (e) {
      print('TopicProvider: Lỗi reload listTopicOfCurrentUser.');
    }
  }
}