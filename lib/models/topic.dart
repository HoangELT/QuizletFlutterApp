import 'package:quizletapp/models/card.dart';

class TopicModel {
  String userId;
  String username;
  String topicId;
  String title;
  String description;
  bool public;
  List<CardModel> listCard;

  TopicModel(this.userId, this.username, this.topicId, this.title, this.description, this.public, this.listCard);

  // Phương thức tạo một Map từ đối tượng TopicModel
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'topicId': topicId,
      'title': title,
      'description': description,
      'public': public,
      'listCard': listCard.map((card) => card.toMap()).toList(), // Chuyển đổi listCard thành List<Map<String, dynamic>>
    };
  }

  // Phương thức tạo danh sách các đối tượng từ danh sách Map
  static List<TopicModel> fromListMap(List<Map<String, dynamic>> listMap) {
    return listMap.map((map) => TopicModel.fromMap(map)).toList();
  }

  // Phương thức tạo đối tượng từ một Map
  static TopicModel fromMap(Map<String, dynamic> map) {
    return TopicModel(
      map['userId'],
      map['username'],
      map['topicId'],
      map['title'],
      map['description'],
      map['public'],
      List<CardModel>.from((map['listCard'] ?? []).map((x) => CardModel.fromMap(x))),
    );
  }
}