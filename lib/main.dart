import 'package:flutter/material.dart';
import 'package:quizletapp/pages/app_page.dart';
import 'package:quizletapp/pages/login_page.dart';
import 'package:quizletapp/pages/not_found_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
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
        primaryColor: Color.fromARGB(255, 10, 4, 60),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => AppPage(),
            );
          case '/login':
            return MaterialPageRoute(
              builder: (context) => LoginPage(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => NotFoundPage(),
            );
        }
      },
    ),
  );
}
