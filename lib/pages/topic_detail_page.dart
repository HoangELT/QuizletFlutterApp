import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/services/models_services/topic_service.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/button_listtile.dart';
import 'package:quizletapp/widgets/text.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TopicDetailPage extends StatefulWidget {
  final String topicId;
  const TopicDetailPage({
    required this.topicId,
    super.key,
  });

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  // final FlutterTts flutterTts = FlutterTts();
  TopicService topicService = TopicService();
  bool isLoading = false;
  TopicModel? topic;
  TopicModel? topicClone;
  TopicModel? topicSortByABC;
  int _current = 0;

  int _currentIndexSort = 0;

  @override
  void initState() {
    _fetchTopic();
    super.initState();
  }

  // Future speak(String textToSpeech) async {
  //   await flutterTts.setLanguage('en-US');
  //   await flutterTts.setPitch(1);
  //   await flutterTts.speak(textToSpeech);
  // }

  Future<void> _fetchTopic() async {
    setState(() {
      isLoading = true;
      _currentIndexSort = 0;
    });
    topic = await topicService.getTopicById(widget.topicId);
    topicClone = (topic == null) ? null : TopicModel.copy(topic!);
    topicSortByABC = (topic == null)
        ? null
        : TopicService.sortTopicByABC(TopicModel.copy(topic!));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackgroundColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTopic,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: (topic != null)
                ? Skeletonizer(
                    enabled: isLoading,
                    containersColor: AppTheme.primaryColorSkeletonContainer,
                    child: Column(
                      children: [
                        const Row(),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              CarouselSlider.builder(
                                itemCount: topic!.listCard.length,
                                itemBuilder: (context, index, realIndex) {
                                  return FlipCard(
                                    fill: Fill.fillBack,
                                    direction: FlipDirection.VERTICAL,
                                    side: CardSide.FRONT,
                                    front: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppTheme
                                                .primaryBackgroundColorAppbar,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: AutoSizeText(
                                            (topic!.listCard[index].term
                                                    .isEmpty)
                                                ? '...'
                                                : topic!.listCard[index].term,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              FontAwesomeIcons.expand,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    back: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppTheme
                                                .primaryBackgroundColorAppbar,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: AutoSizeText(
                                            (topic!.listCard[index].define
                                                    .isEmpty)
                                                ? '...'
                                                : topic!.listCard[index].define,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              FontAwesomeIcons.expand,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                    initialPage: 0,
                                    height: 200,
                                    autoPlayInterval:
                                        const Duration(seconds: 2),
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.3,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 4),
                                child: _buildCarouseIndicator(
                                    topic!.listCard.length),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: topic!.title,
                                  type: TextStyleEnum.xl,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage: AppTheme.defaultAvatar,
                                      backgroundColor: Colors.grey,
                                      radius: 14,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    CustomText(
                                      text: topic!.username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      color:
                                          Colors.grey.shade600.withOpacity(0.5),
                                      width: 1,
                                      height: 18,
                                    ),
                                    CustomText(
                                      text:
                                          '${topic!.listCard.length} thuật ngữ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              if (topic!.description.isNotEmpty)
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 16),
                                  child: CustomText(
                                    text: topic!.description,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              const SizedBox(
                                height: 12,
                              ),
                              InkWell(
                                onTap: () {
                                  print('clicked');
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: ButtonListTile(
                                  padding: const EdgeInsets.only(left: 8),
                                  borderRadius: 8,
                                  title: CustomText(
                                    text: 'Thẻ ghi nhớ',
                                    type: TextStyleEnum.large,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  icon: const Icon(
                                    Icons.library_books_rounded,
                                    color: Color.fromARGB(255, 105, 70, 245),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  print('clicked');
                                },
                                child: ButtonListTile(
                                  padding: const EdgeInsets.only(left: 8),
                                  borderRadius: 8,
                                  title: CustomText(
                                    text: 'Kiểm tra',
                                    type: TextStyleEnum.large,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  icon: const Icon(
                                    Icons.file_copy_rounded,
                                    color: Color.fromARGB(255, 105, 70, 245),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  print('clicked');
                                },
                                child: ButtonListTile(
                                  padding: const EdgeInsets.only(left: 8),
                                  borderRadius: 8,
                                  title: CustomText(
                                    text: 'Gõ từ',
                                    type: TextStyleEnum.large,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  icon: const Icon(
                                    Icons.keyboard,
                                    color: Color.fromARGB(255, 105, 70, 245),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 16),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: 'Thuật ngữ',
                                      type: TextStyleEnum.large,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        var resultChooseTypeSort =
                                            await showModalActionSheet(
                                          context: context,
                                          title: 'Sắp xếp thuật ngữ',
                                          cancelLabel: 'Hủy',
                                          style: AdaptiveStyle.iOS,
                                          actions: [
                                            const SheetAction<int>(
                                                label: 'Theo thứ tự ban đầu',
                                                key: 0),
                                            const SheetAction<int>(
                                                label: 'Bảng chữ cái', key: 1),
                                          ],
                                        );
                                        if (_currentIndexSort !=
                                            resultChooseTypeSort) {
                                          if (resultChooseTypeSort == 0) {
                                            setState(() {
                                              _currentIndexSort = 0;
                                              topic = topicClone;
                                            });
                                          } else if (resultChooseTypeSort ==
                                              1) {
                                            setState(() {
                                              topic = topicSortByABC;
                                              _currentIndexSort = 1;
                                            });
                                          }
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomText(
                                            text: (_currentIndexSort == 0)
                                                ? 'Thứ tự gốc'
                                                : 'Bảng chữ cái',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const Icon(
                                            Icons.sort_rounded,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //List card bottom
                              ...List.generate(topic!.listCard.length, (index) {
                                return Card(
                                  color: AppTheme.primaryBackgroundColorAppbar,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16,
                                                  left: 16,
                                                  bottom: 16),
                                              child: CustomText(
                                                text: (topic!.listCard[index]
                                                        .term.isEmpty)
                                                    ? '...'
                                                    : topic!
                                                        .listCard[index].term,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, right: 8),
                                            child: Wrap(
                                              spacing: -6,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    // speak(topic!
                                                    //     .listCard[index].term);
                                                  },
                                                  icon: const Icon(
                                                    Icons.volume_up_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.star_border_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 16, bottom: 16, right: 16),
                                        child: CustomText(
                                          text: (topic!.listCard[index].define
                                                  .isEmpty)
                                              ? '...'
                                              : topic!.listCard[index].define,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Skeletonizer(
                    enabled: true,
                    containersColor: AppTheme.primaryColorSkeletonContainer,
                    child: Column(
                      children: [
                        const Row(),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              CarouselSlider.builder(
                                itemCount: 3,
                                itemBuilder: (context, index, realIndex) {
                                  return FlipCard(
                                    fill: Fill.fillBack,
                                    direction: FlipDirection.VERTICAL,
                                    side: CardSide.FRONT,
                                    front: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppTheme
                                                .primaryBackgroundColorAppbar,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const AutoSizeText(
                                            'abc def',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              FontAwesomeIcons.expand,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    back: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppTheme
                                                .primaryBackgroundColorAppbar,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const AutoSizeText(
                                            'abc def',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              FontAwesomeIcons.expand,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                    initialPage: 0,
                                    height: 200,
                                    autoPlayInterval:
                                        const Duration(seconds: 2),
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.3,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 4),
                                child: _buildCarouseIndicator(3),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: 'abc def gh',
                                  type: TextStyleEnum.xl,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage: AppTheme.defaultAvatar,
                                      backgroundColor: Colors.grey,
                                      radius: 14,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    CustomText(
                                      text: 'abc def',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      color:
                                          Colors.grey.shade600.withOpacity(0.5),
                                      width: 1,
                                      height: 18,
                                    ),
                                    CustomText(
                                      text: '0 thuật ngữ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ButtonListTile(
                                padding: const EdgeInsets.only(left: 8),
                                borderRadius: 8,
                                title: CustomText(
                                  text: 'Thẻ ghi nhớ',
                                  type: TextStyleEnum.large,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                icon: const Icon(
                                  Icons.library_books_rounded,
                                  color: Color.fromARGB(255, 96, 30, 202),
                                ),
                                onTap: () {
                                  print('clicked');
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ButtonListTile(
                                padding: const EdgeInsets.only(left: 8),
                                borderRadius: 8,
                                title: CustomText(
                                  text: 'Kiểm tra',
                                  type: TextStyleEnum.large,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                icon: const Icon(
                                  Icons.file_copy_rounded,
                                  color: Color.fromARGB(255, 96, 30, 202),
                                ),
                                onTap: () {
                                  print('clicked');
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ButtonListTile(
                                padding: const EdgeInsets.only(left: 8),
                                borderRadius: 8,
                                title: CustomText(
                                  text: 'Gõ từ',
                                  type: TextStyleEnum.large,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                icon: const Icon(
                                  Icons.keyboard,
                                  color: Color.fromARGB(255, 96, 30, 202),
                                ),
                                onTap: () {
                                  print('clicked');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  _buildCarouseIndicator(int itemLength) {
    return AnimatedSmoothIndicator(
      activeIndex: _current,
      count: itemLength,
      effect: ScrollingDotsEffect(
        dotHeight: 5,
        dotWidth: 5,
        strokeWidth: 1.5,
        activeDotColor: const Color.fromARGB(255, 166, 110, 255),
        dotColor: Colors.grey.withOpacity(0.3),
        maxVisibleDots: 9,
      ),
    );
  }
}
