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
}