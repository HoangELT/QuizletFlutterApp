import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/services/shared_references_service.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/text.dart';
import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard.dart';

class CreateTopicPage extends StatefulWidget {
  const CreateTopicPage({Key? key}) : super(key: key);

  @override
  State<CreateTopicPage> createState() => _CreateTopicPageState();
}

class _CreateTopicPageState extends State<CreateTopicPage> {
  int initCardCount = 2;
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
          text: 'Tạo học phần',
          type: TextStyleEnum.large,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings_outlined),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                String? uid =  await SharedPreferencesService().getUID();
                print('uid: $uid');
              } catch (e) {
                print('Lỗi get uid');
              }
              Navigator.pop(context);
            },
            child: CustomText(
              text: 'Xong',
              type: TextStyleEnum.large,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.8),
                    width: 2.0,
                  ),
                ),
              ),
              placeholder: 'Chủ đề, chương, đơn vị',
              placeholderStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: 'Tiêu đề',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return CustomText(text: '$index');
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 8,
                ),
                itemCount: initCardCount,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: CupertinoInputAccessory(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: AppTheme.primaryBackgroundColorAppbar,
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: Colors.white,
                ),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                child: Material(
                  elevation: 4,
                  shape: const CircleBorder(),
                  color: AppTheme.primaryColor,
                  child: IconButton(
                    onPressed: () {
                      print('thêm topic');
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
