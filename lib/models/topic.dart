import 'package:quizletapp/models/card.dart';
import 'package:quizletapp/models/user.dart';

class TopicModel {
  String id;
  String userId;
  String title;
  String description;
  bool public;
  UserModel? userCreate;
  List<CardModel> listCard;
  DateTime dateCreated; // Thêm trường dateCreated kiểu DateTime

  // Constructor mặc định, sử dụng DateTime.now() để gán ngày hiện tại cho dateCreated
  TopicModel(this.id, this.userId, this.title, this.description, this.public,
      this.userCreate, this.listCard)
      : dateCreated = DateTime.now();

  // Correct copy constructor using an initializer list
  TopicModel.copy(TopicModel source)
      : id = source.id,
        userId = source.userId,
        title = source.title,
        description = source.description,
        public = source.public,
        userCreate = source.userCreate,
        listCard = List<CardModel>.from(source.listCard.map((card) =>
            CardModel.copy(card))), // Assuming CardModel has a copy constructor
        dateCreated = source.dateCreated;

  // Phương thức tạo một Map từ đối tượng TopicModel
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId':userId,
      'title': title,
      'description': description,
      'public': public,
      'userCreate': null,
      'listCard': listCard
          .map((card) => card.toMap())
          .toList(), // Chuyển đổi listCard thành List<Map<String, dynamic>>
      'dateCreated': dateCreated
          .toIso8601String(), // Chuyển đổi dateCreated thành chuỗi ISO 8601
    };
  }

  // Phương thức chuyển đổi từ List<TopicModal> sang List<Map<String, dynamic>>
  static List<Map<String, dynamic>> topicsToMapList(List<TopicModel> topics) {
    return topics.map((topic) => topic.toMap()).toList();
  }

  // Phương thức tạo danh sách các đối tượng từ danh sách Map
  static List<TopicModel> fromListMap(List<Map<String, dynamic>> listMap) {
    return listMap.map((map) => TopicModel.fromMap(map)).toList();
  }

  // Phương thức tạo đối tượng từ một Map
  static TopicModel fromMap(Map<String, dynamic> map) {
    return TopicModel(
      map['id'],
      map['userId'],
      map['title'],
      map['description'],
      map['public'],
      map['userCreate'],
      List<CardModel>.from(
          (map['listCard'] ?? []).map((x) => CardModel.fromMap(x))),
    )..dateCreated = DateTime.parse(
        map['dateCreated']); // Chuyển đổi chuỗi ISO 8601 thành DateTime
  }

  @override
  String toString() {
    return 'TopicModel(userId: $userId, username: ${userCreate?.username}, id: $id, title: $title, description: $description, public: $public, listCard: $listCard, dateCreated: $dateCreated)';
  }
}
