import 'package:flutter/material.dart';
import 'package:quizletapp/models/folder.dart';
import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/pages/add_to_folder_page.dart';
import 'package:quizletapp/pages/add_topic_page.dart';
import 'package:quizletapp/pages/app_page.dart';
import 'package:quizletapp/pages/changeEmail_page.dart';
import 'package:quizletapp/pages/changeUserName_page.dart';
import 'package:quizletapp/pages/create_folder.dart';
import 'package:quizletapp/pages/create_topic_page.dart';
import 'package:quizletapp/pages/edit_folder.dart';
import 'package:quizletapp/pages/edit_topic_page.dart';
import 'package:quizletapp/pages/folder_detail_page.dart';
import 'package:quizletapp/pages/library_page.dart';
import 'package:quizletapp/pages/search_topic.dart';
import 'package:quizletapp/pages/intro_page.dart';
import 'package:quizletapp/pages/login_page.dart';
import 'package:quizletapp/pages/not_found_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizletapp/pages/topic_detail_page.dart';
import 'package:quizletapp/pages/topic_info_page.dart';
import 'package:quizletapp/services/firebase_auth.dart';
import 'package:quizletapp/services/providers/current_user_provider.dart';
import 'package:quizletapp/services/providers/folder_provider.dart';
import 'package:quizletapp/services/providers/index_of_app_provider.dart';
import 'package:quizletapp/services/providers/index_of_library_provider.dart';
import 'package:quizletapp/services/providers/topic_provider.dart';
import 'package:quizletapp/utils/custom_scrollbehavior.dart';
import 'pages/changepw_page.dart';
import 'pages/register_page.dart';
import 'firebase_options.dart';
import 'pages/settings_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  usePathUrlStrategy();

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TopicProvider()),
        ChangeNotifierProvider(create: (_) => CurrentUserProvider()),
        ChangeNotifierProvider(create: (_) => FolderProvider()),
        ChangeNotifierProvider(create: (_) => IndexOfAppProvider()),
        ChangeNotifierProvider(create: (_) => IndexOfLibraryProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    context.read<CurrentUserProvider>().initCurrentUse();
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 10, 4, 60),
      ),
      initialRoute: (firebaseAuthService.isUserLoggedIn()) ? '/' : '/intro',
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case '/intro':
            return MaterialPageRoute(
              builder: (context) => const IntroPage(),
            );
          case '/':
            return MaterialPageRoute(
              builder: (context) => const AppPage(),
            );
          case '/login':
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterPage(),
            );
          case '/changeEmail':
            return MaterialPageRoute(
              builder: (context) => const ChangeEmail(),
            );
          case '/changeUserName':
            return MaterialPageRoute(
              builder: (context) => const ChangeUserName(),
            );
          case '/settings':
            return MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            );
          case '/search-topic':
            return MaterialPageRoute(
              builder: (context) => SearchTopicPage(
                keyWord: args as Map<String, dynamic>,
              ),
            );
          case '/changePassword':
            return MaterialPageRoute(
              builder: (context) => const ChangePassWord(),
            );
          case '/topic':
            return MaterialPageRoute(
              builder: (context) => LibraryPage(),
            );

          case '/topic/create':
            return MaterialPageRoute(
              builder: (context) => CreateTopicPage(
                isPop: args == null ? false : args as bool,
              ),
            );
          case '/topic/edit':
            return MaterialPageRoute(
              builder: (context) => EditTopicPage(
                topic: args as TopicModel,
              ),
            );
          case '/topic/add':
            return MaterialPageRoute(
              builder: (context) => AddToFolderPage(topic: args as TopicModel),
            );
          case '/topic/detail':
            return MaterialPageRoute(
              builder: (context) => TopicDetailPage(topicId: args as String),
            );
          case '/topic/info':
            return MaterialPageRoute(
              builder: (context) => TopicInfoPage(topic: args as TopicModel),
            );
          case '/folder':
            context.read<IndexOfLibraryProvider>().changeIndex(1);
            return MaterialPageRoute(
              builder: (context) => LibraryPage(),
            );
          case '/folder/create':
            return MaterialPageRoute(
              builder: (context) => CreateFolderPage(
                isPop: args == null ? false : args as bool,
              ),
            );
          case '/folder/detail':
            return MaterialPageRoute(
              builder: (context) => FolderDetailPage(
                folderId: args as String,
              ),
            );
          case '/folder/add':
            return MaterialPageRoute(
              builder: (context) => AddTopicPage(
                folder: args as FolderModel,
              ),
            );
          case '/folder/edit':
            return MaterialPageRoute(
              builder: (context) => EditFolderPage(
                folder: args as FolderModel,
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const NotFoundPage(),
            );
        }
      },
    );
  }
}
