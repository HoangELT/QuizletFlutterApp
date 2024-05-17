import 'package:flutter/material.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/models/exam_result.dart';
import 'package:quizletapp/models/ranking.dart';
import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/services/models_services/exam_result_service.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RankingPage extends StatefulWidget {
  final TopicModel topic;

  const RankingPage({
    required this.topic,
    super.key,
  });

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with SingleTickerProviderStateMixin {
  ExamResultService examResultService = ExamResultService();

  late final TabController _tabController;

  late TopicModel topic;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    topic = TopicModel.copy(widget.topic);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<RankingModel>> fetchQuantityCorrectRanking() async {
    return await examResultService.getTop20ByQuantityCorrect(widget.topic.id);
  }

  Future<List<RankingModel>> fetchTimeTestRanking() async {
    return await examResultService.getTop20ByTimeTest(widget.topic.id);
  }

  Future<List<RankingModel>> fetchAttemptsRanking() async {
    return await examResultService.getTop20ByAttempts(widget.topic.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppTheme.primaryBackgroundColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 3,
          dividerHeight: 3,
          overlayColor:
              const MaterialStatePropertyAll(AppTheme.primaryBackgroundColor),
          dividerColor: Colors.transparent,
          indicatorColor: Colors.deepPurpleAccent.shade100,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          labelStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 32),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(
              text: 'Thần đồng',
            ),
            Tab(
              text: 'Vua tốc độ',
            ),
            Tab(
              text: 'Chăm chỉ',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder(
            future: fetchQuantityCorrectRanking(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  child: CustomText(text: '${snapshot.data}'),
                );
              } else if (snapshot.hasError) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 32),
                );
              } else {
                return Skeletonizer(
                  enabled: true,
                  containersColor: AppTheme.primaryColorSkeletonContainer,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 32),
                  ),
                );
              }
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 32),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 32),
          ),
        ],
      ),
    );
  }
}
