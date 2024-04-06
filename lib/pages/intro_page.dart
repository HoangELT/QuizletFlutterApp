import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/button.dart';
import 'package:quizletapp/widgets/elevatedButton.dart';
import 'package:quizletapp/widgets/text.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Scaffold(
        backgroundColor: AppTheme.primaryBackgroundColorAppbar,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: CustomText(
            text: "Quizlet",
            type: TextStyleEnum.xxl,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
                size: 36,
              ),
            ),
            const SizedBox(width: 20),
          ],
          backgroundColor: AppTheme.primaryBackgroundColorAppbar,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 400, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
                text: "Đăng ký miễn phí",
              ),
              const SizedBox(height: 15),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                text: "Hoặc đăng nhập",
              )
            ],
          ),
        ),
      ),
    );
  }
}
