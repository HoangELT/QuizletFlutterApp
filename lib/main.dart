import 'package:flutter/material.dart';
import 'package:quizletapp/pages/app_page.dart';
import 'package:quizletapp/pages/changeEmail_page.dart';
import 'package:quizletapp/pages/changeUserName_page.dart';
import 'package:quizletapp/pages/create_folder.dart';
import 'package:quizletapp/pages/create_topic_page.dart';
import 'package:quizletapp/pages/library_page.dart';
import 'package:quizletapp/pages/search_topic.dart';
import 'package:quizletapp/pages/intro_page.dart';
import 'package:quizletapp/pages/login_page.dart';
import 'package:quizletapp/pages/not_found_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizletapp/services/firebase_auth.dart';
import 'package:quizletapp/services/provider/current_user_provider.dart';
import 'package:quizletapp/services/provider/folder_provider.dart';
import 'package:quizletapp/services/provider/index_of_app_provider.dart';
import 'package:quizletapp/services/provider/index_of_library_provider.dart';
import 'package:quizletapp/services/provider/topic_provider.dart';
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
              builder: (context) => LibraryPage(
              ),
            );
          case '/folder':
            context.read<IndexOfLibraryProvider>().changeIndex(1);
            return MaterialPageRoute(
              builder: (context) => LibraryPage(
              ),
            );
          case '/topic/create':
            return MaterialPageRoute(
              builder: (context) => const CreateTopicPage(),
            );
          case '/folder/create':
            return MaterialPageRoute(
              builder: (context) => const CreateFolderPage(),
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
