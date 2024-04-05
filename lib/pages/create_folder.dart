import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/text.dart';

class CreateFolderPage extends StatefulWidget {
  const CreateFolderPage({super.key});

  @override
  State<CreateFolderPage> createState() => _CreateFolderPageState();
}

class _CreateFolderPageState extends State<CreateFolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppTheme.primaryBackgroundColor,
        title: CustomText(
          text: 'Thư mục mới',
          type: TextStyleEnum.large,
        ),
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: CustomText(
              text: 'Hủy',
            ),
          ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: CustomText(
              text: 'Lưu',
              type: TextStyleEnum.large,
            ),
          ),
        ],
      ),
      body: Center(
        child: CustomText(
          text: 'create new folder page',
        ),
      ),
    );
  }
}
