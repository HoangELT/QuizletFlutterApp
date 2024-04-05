import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/text.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
        centerTitle: true,
        backgroundColor: AppTheme.primaryBackgroundColor,
        title: CustomText(
          text: 'Thư viện',
          type: TextStyleEnum.large,
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            margin: const EdgeInsets.symmetric(vertical: 32),
            child: SingleChildScrollView(
              child: CustomText(
                text: 'Thư mục',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitContent() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 64,
      ),
      child: Column(
        children: [
          const Row(),
          CircleAvatar(
            backgroundImage: AppTheme.defaultAvatar,
            radius: 28,
          ),
          const SizedBox(
            height: 8,
          ),
          CustomText(
            text: 'Xin chào daicuong!',
            type: TextStyleEnum.large,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Divider(),
                CustomText(
                  text: 'Bắt đầu bằng cách tìm học phần hoặc tự tạo học phần',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey.shade300),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
