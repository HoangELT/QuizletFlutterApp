import 'package:quizletapp/models/topic.dart';

class FolderModel {
  String folderId;
  String title;
  String description;
  List<TopicModel> listTopic;

  FolderModel(this.folderId, this.title, this.description, this.listTopic);

  // Phương thức tạo danh sách các đối tượng từ danh sách Map
  static List<FolderModel> fromListMap(List<Map<String, dynamic>> listMap) {
    return listMap.map((map) => FolderModel.fromMap(map)).toList();
  }

  // Phương thức tạo đối tượng từ một Map
  static FolderModel fromMap(Map<String, dynamic> map) {
    return FolderModel(
      map['folderId'],
      map['title'],
      map['description'],
      List<TopicModel>.from((map['listTopic'] ?? []).map((x) => TopicModel.fromMap(x))),
    );
  }
}
