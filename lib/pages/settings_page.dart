import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: AppTheme.primaryBackgroundColor,
        title: CustomText(
          text: "Cài đặt",
          type: TextStyleEnum.large,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomText(text: "Thông tin cá nhân"),
            Container(),
          ],
        ),
      ),
    );
  }
}
