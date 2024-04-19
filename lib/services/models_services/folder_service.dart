import 'package:quizletapp/models/folder.dart';
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
        var listFolderOfCurrentUserByDateDescending =
            sortFoldersByDateDescending(FolderModel.fromListMap(listFolderOfCurrentUser));
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
      print('FolderService error: ${e}');
    }
  }

  static List<FolderModel> sortFoldersByDate(List<FolderModel> folders) {
    folders.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
    return folders;
  }

  static List<FolderModel> sortFoldersByDateDescending(List<FolderModel> folders) {
    folders.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    return folders;
  }

  static void printListFolders(List<FolderModel> listFolders) {
    print('List folders:');
    for (var i in listFolders) {
      print(i.toString());
    }
  }
}
