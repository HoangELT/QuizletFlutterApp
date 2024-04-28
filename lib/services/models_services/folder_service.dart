import 'dart:async';

import 'package:quizletapp/models/folder.dart';
import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/services/firebase.dart';
import 'package:quizletapp/services/firebase_auth.dart';

class FolderService {
  FirebaseService firebaseService = FirebaseService();
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  Future<List<FolderModel>> getAllTopicOfCurrentUser() async {
    try {
      var currentUser = firebaseAuthService.getCurrentUser();
      if (currentUser != null) {
        var listFolderOfCurrentUser = await firebaseService.getDocumentsByField(
            'folders', 'userId', currentUser.uid);

        var listFolderModelOfCurrentUser =
            FolderModel.fromListMap(listFolderOfCurrentUser);

        for (var folder in listFolderModelOfCurrentUser) {
          var listTopicByIds = await firebaseService.getDocumentsByDocumentIds(
              'topics', folder.listTopicId);
          folder.listTopic = TopicModel.fromListMap(listTopicByIds);
        }

        var listFolderOfCurrentUserByDateDescending =
            sortFoldersByDateDescending(listFolderModelOfCurrentUser);

        print('listFolder: $listFolderOfCurrentUserByDateDescending');
        return listFolderOfCurrentUserByDateDescending;
      }
    } catch (e) {
      print('FolderService error: $e');
    }
    return [];
  }

  Future<void> addFolder(FolderModel newFolder) async {
    try {
      await firebaseService.addDocument('folders', newFolder.toMap());
    } catch (e) {
      print('FolderService error( getAllTopicOfCurrentUser ): ${e}');
    }
  }

  Future<void> addTopicToFolder(FolderModel folder, String topicId) async {
    try {
      if (folder.listTopicId.contains(topicId)) return;
      folder.listTopicId.add(topicId);
      await firebaseService.updateDocument(
          'folders', folder.id, folder.toMap());
    } catch (e) {
      print('FolderService error( addTopicToFolder ): $e');
    }
  }

  Future<void> removeTopicInFolder(FolderModel folder, String topicId) async {
    try {
      if (!folder.listTopicId.contains(topicId)) return;
      folder.listTopicId.remove(topicId);
      await firebaseService.updateDocument(
          'folders', folder.id, folder.toMap());
    } catch (e) {
      print('FolderService error( addTopicToFolder ): $e');
    }
  }

  Future<List<FolderModel>> getListFolderByFolderIds(
      List<String> folderIds) async {
    List<FolderModel> list = [];
    try {
      var listResult =
          await firebaseService.getDocumentsByDocumentIds('folders', folderIds);
      list = FolderModel.fromListMap(listResult);
    } catch (e) {
      print('FolderService error( addTopicToFolder ): $e');
    }
    return list;
  }

  static List<FolderModel> sortFoldersByDate(List<FolderModel> folders) {
    folders.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
    return folders;
  }

  static List<FolderModel> sortFoldersByDateDescending(
      List<FolderModel> folders) {
    folders.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    return folders;
  }

  static List<FolderModel> getListFolderContainsTopic(
      List<FolderModel> list, String topicId) {
    List<FolderModel> listResult = [];

    for (FolderModel folder in list) {
      if (folder.listTopicId.contains(topicId)) {
        listResult.add(folder);
      }
    }

    return listResult;
  }

  static void printListFolders(List<FolderModel> listFolders) {
    print('List folders:');
    for (var i in listFolders) {
      print(i.toString());
    }
  }
}
