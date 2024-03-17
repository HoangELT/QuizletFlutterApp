import 'package:quizletapp/models/topic.dart';

class FolderModel {
  String folderId;
  String title;
  String description;
  List<TopicModel> listTopic;
  FolderModel(this.folderId, this.title, this.description, this.listTopic);
}