import 'package:flutter/material.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/button.dart';
import 'package:quizletapp/widgets/text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      // appBar: AppBar(
      //   title: Text('Quizlet'),
      //   foregroundColor: Colors.white,
      //   backgroundColor: AppTheme.primaryBackgroundColorAppbar,
      // ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          CustomText(
            text: 'Các học phần',
            type: TextStyleEnum.xl,
          ),
          CustomButton(text: 'Bắt đầu ôn tập', onTap: () {print('abc');},),
        ]),
      ),
    );
  }
}
