import 'package:flutter/material.dart';
import 'package:quizletapp/models/folder.dart';
import 'package:quizletapp/services/models_services/folder_service.dart';

class FolderProvider extends ChangeNotifier{
  FolderService folderService = FolderService();

  List<FolderModel> _listFolderOfCurrentUser = [];

  List<FolderModel> get listFolderOfCurrentUser => _listFolderOfCurrentUser;

  Future<void> reloadListFolderOfCurrentUser () async {
    try {
      _listFolderOfCurrentUser = await folderService.getAllTopicOfCurrentUser();
      notifyListeners();
    } catch (e) {
      print('FolderProvider error: $e');
    }
  }
}