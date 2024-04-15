import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/services/firebase_auth.dart';
import 'package:quizletapp/services/provider/current_user_provider.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LibraryPage extends StatefulWidget {
  int initIndex;
  LibraryPage({
    this.initIndex = 0,
    super.key,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool isLoading = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setState(() {
      _tabController.index = widget.initIndex;
    });
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
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: AppTheme.primaryBackgroundColor,
        title: CustomText(
          text: 'Thư viện',
          type: TextStyleEnum.large,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_tabController.index == 0) {
                print('add topic');
                Navigator.pushNamed(context, '/topic/create');
              } else if (_tabController.index == 1) {
                Navigator.pushNamed(context, '/folder/create');
              }
            },
            icon: const Icon(
              Icons.add,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: TabBar(
              controller: _tabController,
              indicatorWeight: 3,
              dividerHeight: 3,
              overlayColor: const MaterialStatePropertyAll(
                  AppTheme.primaryBackgroundColor),
              dividerColor: Colors.grey.shade600.withOpacity(0.5),
              indicatorColor: Colors.deepPurpleAccent.shade100,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.white,
              labelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(right: 32),
              tabs: const [
                Tab(
                  text: 'Học phần',
                ),
                Tab(
                  text: 'Thư mục',
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        print('Clicked button sắp xếp');
                      },
                      style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              width: 2, color: Colors.grey.withOpacity(0.8)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Wrap(
                          spacing: 4,
                          children: [
                            CustomText(text: 'Tất cả'),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildInitContent(),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 64,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: _buildInitFolderPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildInitContent() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 64,
      ),
      child: SingleChildScrollView(
        child: Skeletonizer(
          enabled: isLoading,
          containersColor: Colors.grey.shade400,
          child: Column(
            children: [
              const Row(),
              const CircleAvatar(
                backgroundImage: AppTheme.defaultAvatar,
                radius: 28,
              ),
              const SizedBox(
                height: 8,
              ),
              CustomText(
                text: 'Xin chào ${context.watch<CurrentUserProvider>().currentUser!.username}!',
                type: TextStyleEnum.large,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Divider(),
                    CustomText(
                      text:
                          'Bắt đầu bằng cách tìm học phần hoặc tự tạo học phần',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade300),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitFolderPage() {
    return Column(
      children: [
        const Icon(
          FontAwesomeIcons.solidFolderOpen,
          color: Colors.blue,
          size: 44,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 32,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: CustomText(
            text: 'Sắp xếp học phần của bạn theo chủ đề.',
            type: TextStyleEnum.xl,
            textAlign: TextAlign.center,
          ),
        ),
        Ink(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/folder/create');
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: CustomText(
                text: 'Tạo thư mục',
                type: TextStyleEnum.large,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
