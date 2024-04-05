import 'package:flutter/material.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/group_list.dart';
import 'package:quizletapp/widgets/item_list.dart';
import 'package:quizletapp/widgets/text.dart';

class FindTopicPage extends StatefulWidget {
  final Map<String, dynamic> keyWord;

  FindTopicPage({
    required this.keyWord,
    super.key,
  });

  @override
  State<FindTopicPage> createState() => _FindTopicPageState();
}

class _FindTopicPageState extends State<FindTopicPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List listTopicToFind = ['Nghệ thuật và nhân văn', 'Ngôn ngữ', 'Toán học'];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 32),
        automaticallyImplyLeading: true,
        backgroundColor: AppTheme.primaryBackgroundColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: widget.keyWord['key'].toString(),
                  type: TextStyleEnum.xxl,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  indicatorWeight: 3,
                  dividerHeight: 3,
                  dividerColor: Colors.grey.shade600.withOpacity(0.5),
                  indicatorColor: Colors.deepPurpleAccent.shade100,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.white,
                  labelStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.only(right: 32),
                  tabs: const [
                    Tab(
                      text: 'Tất cả',
                    ),
                    Tab(
                      text: 'Học phần',
                    ),
                    Tab(
                      text: 'Người dùng',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 32),
            child: SingleChildScrollView(
              child: GroupList(
                itemHeight: null,
                isList: true,
                itemCount: 3,
                title: 'Học phần',
                isShowOption: false,
                builList: (index) {
                  return Column(
                    children: [
                      if (index != 0)
                        const SizedBox(
                          height: 16,
                        ),
                      ItemList(
                        width: null,
                        height: 180,
                        headText: 'Test',
                        bodyText: '${10} thuật ngữ',
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
                                CustomText(text: 'daicuong')
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 32),
            child: SingleChildScrollView(
              child: GroupList(
                itemHeight: null,
                isList: true,
                itemCount: 3,
                title: 'Người dùng',
                isShowOption: false,
                builList: (index) {
                  return Column(
                    children: [
                      if (index != 0)
                        const SizedBox(
                          height: 16,
                        ),
                      ItemList(
                        width: null,
                        height: 180,
                        headText: 'Test',
                        bodyText: '${10} thuật ngữ',
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
                                CustomText(text: 'daicuong')
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 32),
            child: SingleChildScrollView(
              child: GroupList(
                itemHeight: null,
                isList: true,
                itemCount: 3,
                title: 'Học phần',
                isShowOption: false,
                builList: (index) {
                  return Column(
                    children: [
                      if (index != 0)
                        const SizedBox(
                          height: 16,
                        ),
                      ItemList(
                        width: null,
                        height: 180,
                        headText: 'Test',
                        bodyText: '${10} thuật ngữ',
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
                                CustomText(text: 'daicuong')
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
