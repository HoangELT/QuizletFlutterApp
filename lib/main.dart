import 'package:flutter/material.dart';
import 'package:quizletapp/pages/app_page.dart';
import 'package:quizletapp/pages/intro_page.dart';
import 'package:quizletapp/pages/login_page.dart';
import 'package:quizletapp/pages/not_found_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizletapp/pages/register_page.dart';
import 'firebase_options.dart';

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
          case '/':
            return MaterialPageRoute(
              builder: (context) => const IntroPage(),
            );
          case '/app':
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
          default:
            return MaterialPageRoute(
              builder: (context) => const NotFoundPage(),
            );
        }
      },
    ),
  );
}
