import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/models/folder.dart';
import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/models/user.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/text.dart';
import 'package:quizletapp/widgets/group_list.dart';
import 'package:quizletapp/widgets/item_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel currentUser = UserModel(
      '0', 'lydaicuong784', 'lydaicuong784@gmail.com', DateTime.now());

  List<TopicModel> myTopics = [
    TopicModel('0', 'daicuong', '0', 'Famous', 'description', true, []),
    TopicModel('0', 'daicuong', '0', 'Famous', 'description', true, []),
    TopicModel('0', 'daicuong', '0', 'Famous', 'description', true, []),
    TopicModel('0', 'daicuong', '0', 'Famous', 'description', true, []),
  ];

  List<TopicModel> listTopicOfUser = [
    TopicModel('0', 'daicuong', '0', 'Famous', 'description', true, []),
    TopicModel('0', 'daicuong', '0', 'Famous', 'description', true, []),
    TopicModel('0', 'daicuong', '0', 'Famous', 'description', true, []),
    TopicModel('0', 'daicuong', '0', 'Famous', 'description', true, []),
  ];

  List<FolderModel> listFolder = [
    FolderModel('0', 'Folder 1', 'description', []),
    FolderModel('0', 'Folder 2', 'description', []),
    FolderModel('0', 'Folder 3', 'description', []),
    FolderModel('0', 'Folder 4', 'description', []),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(52),
            bottomRight: Radius.circular(52),
          ),
        ),
        title: CustomText(
          text: 'Quizlet',
          type: TextStyleEnum.xl,
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppTheme.primaryBackgroundColorAppbar,
        actions: [
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(AppTheme.primaryButtonColor),
            ),
            onPressed: () {},
            child: CustomText(
              text: 'Nâng cấp',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 32,
                ),
              ),
              Positioned(
                top: 0,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: CustomText(
                    text: '2',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 8,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 18),
            child: TextField(
              style: const TextStyle(
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintText: 'Học phần, sách giáo khoa, câu hỏi',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9999),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: const Icon(Icons.search),
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: const Icon(Icons.camera_alt_outlined),
                ),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 32),
          child: Column(
            children: [
              GroupList(
                buildItem: (context, index) {
                  return ItemList(
                    headText: myTopics[index].title,
                    bodyText: '${myTopics[index].listCard.length} thuật ngữ',
                    bottom: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 14,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomText(text: myTopics[index].username)
                      ],
                    ),
                  );
                },
                itemCount: myTopics.length,
                title: 'Các học phần',
                onShowAll: () {
                  print('show');
                },
              ),
              const SizedBox(
                height: 32,
              ),
              GroupList(
                buildItem: (context, index) {
                  return ItemList(
                    headText: myTopics[index].title,
                    bodyText: '${myTopics[index].listCard.length} thuật ngữ',
                    bottom: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 14,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            CustomText(text: myTopics[index].username)
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            print(index.toString());
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: listTopicOfUser.length,
                title: 'Tương tự học phần của ${listTopicOfUser[0].username}',
                isShowOption: false,
              ),
              const SizedBox(
                height: 32,
              ),
              GroupList(
                buildItem: (context, index) {
                  return ItemList(
                    head: Row(
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          color: Colors.grey.withOpacity(0.6),
                          size: 28,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        CustomText(
                          text: listFolder[index].title,
                          type: TextStyleEnum.large,
                        ),
                      ],
                    ),
                    body: Row(
                      children: [
                        CustomText(text: '${listFolder.length} học phần'),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.grey.shade600.withOpacity(0.5),
                          width: 1,
                          height: 18,
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 14,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomText(text: myTopics[index].username)
                      ],
                    ),
                  );
                },
                itemCount: listFolder.length,
                title: 'Thư mục',
                isShowOption: false,
                itemHeight: 108,
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
