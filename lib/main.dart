import 'package:flutter/material.dart';
import 'package:quizletapp/pages/app_page.dart';
import 'package:quizletapp/pages/search_topic.dart';
import 'package:quizletapp/pages/intro_page.dart';
import 'package:quizletapp/pages/login_page.dart';
import 'package:quizletapp/pages/not_found_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/changepw_page.dart';
import 'pages/register_page.dart';
import 'firebase_options.dart';
import 'pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  usePathUrlStrategy();
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 10, 4, 60),
      ),
      initialRoute: '/',
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
          case '/forgotPassword':
            return MaterialPageRoute(
              builder: (context) => const ChangePassWord(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const NotFoundPage(),
            );
        }
      },
    ),
  );
}
