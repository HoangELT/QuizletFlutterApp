import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/text.dart';

import '../services/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FirebaseAuthService auth = FirebaseAuthService();
  var userName = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    var user = auth.getCurrentUser();
    setState(() {
      userName = user!.email.toString();
    });
  }

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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                  child: CustomText(
                    text: "Thông tin cá nhân",
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  decoration: createBoxDecoration(),
                  child: Column(
                    children: [
                      createInkWell(userName, "Tên người dùng", () {
                        print("object");
                      }),
                      const Divider(thickness: 1.0),
                      createInkWell(userName, "Email", () {
                        print("asdasd");
                      }),
                      const Divider(thickness: 1.0),
                      createInkWell('', "Đổi mật khẩu", () {
                        Navigator.pushNamed(context, "/forgotPassword");
                      }),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  createInkWell(String text, String info, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.white.withOpacity(0),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          children: [
            createCheckText(text, info),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  createCheckText(String text, String info) {
    if (text.isEmpty) {
      return CustomText(
        text: info,
        type: TextStyleEnum.large,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: info,
          type: TextStyleEnum.large,
        ),
        const SizedBox(height: 5),
        CustomText(
          text: text,
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }

  createBoxDecoration() {
    return BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)));
  }
}
