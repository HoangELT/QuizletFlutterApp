import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/models/card.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/button_active.dart';
import 'package:quizletapp/widgets/text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LearnFlashCards extends StatefulWidget {
  List<CardModel> listCard;
  LearnFlashCards({
    required this.listCard,
    super.key,
  });

  @override
  State<LearnFlashCards> createState() => _LearnFlashCardsState();
}

class _LearnFlashCardsState extends State<LearnFlashCards> {
  final FlutterTts flutterTts = FlutterTts();

  final appinioSwiperController = AppinioSwiperController();
  final _flipController = FlipCardController();

  int _settingIndex = 1;
  bool isMix = false;
  bool isVolume = false;
  bool isEnd = false;
  bool isAutoPlay = false;
  double positionValueChanges = 0;

  List<CardSide> listCardSide = [CardSide.FRONT, CardSide.BACK];

  FocusNode autoPlayFocus = FocusNode();

  List<CardModel> listLeft = [];
  List<CardModel> listRight = [];
  List<CardModel> listShow = [];

  @override
  void dispose() {
    // TODO: implement dispose
    appinioSwiperController.dispose();
    autoPlayFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initValueState();
    super.initState();
  }

  initValueState() async {
    final prefs = await SharedPreferences.getInstance();
    bool? mix = prefs.getBool('isMix');
    bool? volume = prefs.getBool('isVolume');
    int? index = prefs.getInt('settingIndex');
    setState(() {
      isMix = mix ?? false;
      isVolume = volume ?? false;
      _settingIndex = index ?? 1;
    });
    if (isVolume) {
      if (_settingIndex == 0) {
        speak(widget.listCard[appinioSwiperController.cardIndex!].term);
      } else {
        speak(widget.listCard[appinioSwiperController.cardIndex!].define);
      }
    }
  }

  initListShow() {
    setState(() {
      listShow = List.from(widget.listCard);
    });
  }

  void rollBack(CardModel itemRollBack) {
    if (listLeft.contains(itemRollBack)) {
      setState(() {
        listLeft.remove(itemRollBack);
      });
      print('remove left');
    } else if (listRight.contains(itemRollBack)) {
      setState(() {
        listRight.remove(itemRollBack);
      });
      print('remove right');
    }
    setState(() {
      appinioSwiperController.setCardIndex(appinioSwiperController.cardIndex!);
    });
  }

  void setSettingIndex(int index) {
    setState(() {
      _settingIndex = index;
    });
  }

  double getOpacity(double position) {
    double absPosition = position.abs();

    if (absPosition > 2.5) {
      return 1.0;
    }

    if (absPosition < 0.1) {
      return 0.0;
    }

    // if (absPosition < 0.6) return 0.3;

    return (absPosition - 0.1) / (2.4);
  }

  int getOpacityInt(double position) {
    double absPosition = position.abs();

    if (absPosition > 2.5) {
      return 255;
    }

    if (absPosition < 0.1) {
      return 1;
    }

    double linearMapping = ((absPosition - 0.1) / 2.4) * (255 - 1) + 1;

    return linearMapping.round();
  }

  Future<void> speak(String textToSpeech, {String language = 'en-US'}) async {
    try {
      // Set language to English (US)
      var resultLanguage = await flutterTts.setLanguage(language);
      if (resultLanguage == 1) {
      } else {
        return;
      }
      // Set pitch level
      var resultPitch = await flutterTts.setPitch(0.8);
      if (resultPitch == 1) {
      } else {
        return;
      }

      // Start speaking
      var resultSpeak = await flutterTts.speak(textToSpeech);
      if (resultSpeak == 1) {
      } else {
        print('Failed to speak');
        return;
      }
    } catch (e) {
      print('Error occurred in TTS operation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackgroundColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Stack(
            children: [
              Container(
                color: Colors.grey,
                height: 3,
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    ...List.generate(widget.listCard.length, (index) {
                      if (appinioSwiperController.cardIndex != null &&
                          appinioSwiperController.cardIndex! > index) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            color: Colors.white,
                          ),
                        );
                      }
                      return Expanded(
                        child: Container(
                          height: 4,
                          color: Colors.transparent,
                        ),
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
        title: CustomText(
          text:
              '${(appinioSwiperController.cardIndex == null) ? 1 : (appinioSwiperController.cardIndex! + 1) > widget.listCard.length ? appinioSwiperController.cardIndex! : appinioSwiperController.cardIndex! + 1}/${widget.listCard.length}',
          type: TextStyleEnum.large,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.close,
            size: 28,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: AppTheme.primaryBackgroundColor,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.9,
                        widthFactor: 1,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 44,
                                height: 6,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(160, 127, 144, 155),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomText(
                                text: 'Tùy chọn',
                                type: TextStyleEnum.xl,
                              ),
                              Divider(
                                color: Colors.grey.shade800,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ButtonActive(
                                          initValue: isMix,
                                          titleText: 'Trộn thẻ',
                                          onChange: (state) async {
                                            setState(() {
                                              isMix = state;
                                            });
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setBool('isMix', state);
                                          },
                                        ),
                                        ButtonActive(
                                          initValue: isVolume,
                                          titleText: 'Phát bản thu',
                                          iconData: Icons.volume_up,
                                          onChange: (state) async {
                                            setState(() {
                                              isVolume = state;
                                            });
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setBool(
                                                'isVolume', state);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    CustomText(
                                      text: 'Thiết lập thẻ ghi nhớ',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    CustomText(text: 'Mặt trước'),
                                    Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      child: ToggleSwitch(
                                        animate: true,
                                        animationDuration: 200,
                                        minWidth: double.infinity,
                                        cornerRadius: 20.0,
                                        activeBgColors: [
                                          [Colors.green[800]!],
                                          [Colors.red[800]!]
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor:
                                            Colors.grey.withOpacity(0.3),
                                        inactiveFgColor: Colors.white,
                                        initialLabelIndex: _settingIndex,
                                        totalSwitches: 2,
                                        labels: const [
                                          'Thuật ngữ',
                                          'Định nghĩa'
                                        ],
                                        customTextStyles: const [
                                          TextStyle(
                                              fontWeight: FontWeight.w500),
                                          TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ],
                                        radiusStyle: true,
                                        onToggle: (index) async {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          if (index == 0) {
                                            setSettingIndex(0);

                                            await prefs.setInt(
                                                'settingIndex', 0);
                                          } else {
                                            setSettingIndex(1);
                                            await prefs.setInt(
                                                'settingIndex', 1);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 48,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 6,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(999),
                          topEnd: Radius.circular(999),
                        ),
                        border: Border(
                          top: BorderSide(
                              width: 1, color: Color.fromARGB(255, 255, 95, 8)),
                          right: BorderSide(
                              width: 1, color: Color.fromARGB(255, 255, 95, 8)),
                          bottom: BorderSide(
                              width: 1, color: Color.fromARGB(255, 255, 95, 8)),
                        ),
                      ),
                      child: CustomText(
                        text: '${listLeft.length}',
                        type: TextStyleEnum.large,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 95, 8)),
                      ),
                    ),
                    if (positionValueChanges < 0)
                      Positioned.fill(
                        child: Container(
                          width: 48,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 95, 8)
                                .withOpacity(getOpacity(positionValueChanges)),
                            borderRadius: const BorderRadiusDirectional.only(
                              bottomEnd: Radius.circular(999),
                              topEnd: Radius.circular(999),
                            ),
                            border: const Border(
                              top: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 255, 95, 8)),
                              right: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 255, 95, 8)),
                              bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 255, 95, 8)),
                            ),
                          ),
                          child: CustomText(
                            text: '+1',
                            type: TextStyleEnum.large,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      width: 48,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 6,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(999),
                          topStart: Radius.circular(999),
                        ),
                        border: Border(
                          top: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 57, 255, 63)),
                          left: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 57, 255, 63)),
                          bottom: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 57, 255, 63)),
                        ),
                      ),
                      child: CustomText(
                        text: '${listRight.length}',
                        type: TextStyleEnum.large,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 57, 255, 63)),
                      ),
                    ),
                    if (positionValueChanges > 0)
                      Positioned.fill(
                        child: Container(
                          width: 48,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 57, 255, 63)
                                .withOpacity(getOpacity(positionValueChanges)),
                            borderRadius: const BorderRadiusDirectional.only(
                              bottomStart: Radius.circular(999),
                              topStart: Radius.circular(999),
                            ),
                            border: const Border(
                              top: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 57, 255, 63)),
                              left: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 57, 255, 63)),
                              bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 57, 255, 63)),
                            ),
                          ),
                          child: CustomText(
                            text: '+1',
                            type: TextStyleEnum.large,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: AppinioSwiper(
                initialIndex: 0,
                controller: appinioSwiperController,
                backgroundCardScale: 1,
                backgroundCardOffset:
                    Offset.fromDirection(BorderSide.strokeAlignCenter),
                cardCount: widget.listCard.length,
                onCardPositionChanged: (position) {
                  setState(() {
                    positionValueChanges = position.angle;
                  });
                },
                onSwipeCancelled: (activity) {
                  setState(() {
                    positionValueChanges = 0;
                  });
                },
                onSwipeEnd: (previousIndex, targetIndex, activity) {
                  try {
                    if (previousIndex == targetIndex) return;
                    if (previousIndex > targetIndex) {
                      rollBack(widget.listCard[targetIndex]);
                    } else {
                      if (activity.currentOffset.dx < 0) {
                        setState(() {
                          listLeft.add(widget.listCard[previousIndex]);
                        });
                      } else {
                        setState(() {
                          listRight.add(widget.listCard[previousIndex]);
                        });
                      }
                    }
                    setState(() {
                      positionValueChanges = 0;
                    });
                    if (isVolume &&
                        appinioSwiperController.cardIndex != null &&
                        appinioSwiperController.cardIndex! <
                            widget.listCard.length) {
                      if (_settingIndex == 0) {
                        speak(widget
                            .listCard[appinioSwiperController.cardIndex!].term);
                      } else {
                        speak(widget
                            .listCard[appinioSwiperController.cardIndex!]
                            .define);
                      }
                    }
                  } catch (e) {
                    print('lỗi dòng 476: $e');
                  }
                },
                cardBuilder: (context, index) {
                  return FlipCard(
                    fill: Fill.fillBack,
                    direction: FlipDirection.HORIZONTAL,
                    side: listCardSide[_settingIndex],
                    controller: _flipController,
                    front: Stack(
                      children: [
                        Card(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 40),
                            decoration: BoxDecoration(
                              border: (positionValueChanges == 0 ||
                                      appinioSwiperController.cardIndex !=
                                          index)
                                  ? null
                                  : Border.all(
                                      width: 2,
                                      color: (positionValueChanges > 0)
                                          ? const Color.fromARGB(
                                              255, 57, 255, 63)
                                          : const Color.fromARGB(
                                              255, 255, 169, 40),
                                    ),
                              color: AppTheme.primaryBackgroundColorAppbar,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: AutoSizeText(
                              (widget.listCard[index].term.isEmpty)
                                  ? '...'
                                  : widget.listCard[index].term,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(
                                      1 - getOpacity(positionValueChanges)),
                                  fontSize: 28),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 16,
                          child: IconButton(
                            onPressed: () {
                              speak(widget.listCard[index].term);
                              print('index: $_settingIndex');
                            },
                            icon: const Icon(
                              Icons.volume_up_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        (positionValueChanges > 0)
                            ? Positioned.fill(
                                child: Center(
                                  child: CustomText(
                                    text: 'Đã biết',
                                    type: TextStyleEnum.xxl,
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            getOpacityInt(positionValueChanges),
                                            14,
                                            251,
                                            25)),
                                  ),
                                ),
                              )
                            : Positioned.fill(
                                child: Center(
                                  child: CustomText(
                                    text: 'Đang học',
                                    type: TextStyleEnum.xxl,
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            getOpacityInt(positionValueChanges),
                                            255,
                                            95,
                                            8)),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    back: Stack(
                      children: [
                        Card(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 40),
                            decoration: BoxDecoration(
                              border: (positionValueChanges == 0 ||
                                      appinioSwiperController.cardIndex !=
                                          index)
                                  ? null
                                  : Border.all(
                                      width: 2,
                                      color: (positionValueChanges > 0)
                                          ? const Color.fromARGB(
                                              255, 57, 255, 63)
                                          : const Color.fromARGB(
                                              255, 255, 169, 40)),
                              color: AppTheme.primaryBackgroundColorAppbar,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: AutoSizeText(
                              (widget.listCard[index].define.isEmpty)
                                  ? '...'
                                  : widget.listCard[index].define,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(
                                      1 - getOpacity(positionValueChanges)),
                                  fontSize: 28),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 16,
                          child: IconButton(
                            onPressed: () {
                              speak(widget.listCard[index].define);
                            },
                            icon: const Icon(
                              Icons.volume_up_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        (positionValueChanges > 0)
                            ? Positioned.fill(
                                child: Center(
                                  child: CustomText(
                                    text: 'Đã biết',
                                    type: TextStyleEnum.xxl,
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            getOpacityInt(positionValueChanges),
                                            14,
                                            251,
                                            25)),
                                  ),
                                ),
                              )
                            : Positioned.fill(
                                child: Center(
                                  child: CustomText(
                                    text: 'Đang học',
                                    type: TextStyleEnum.xxl,
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            getOpacityInt(positionValueChanges),
                                            255,
                                            95,
                                            8)),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () async {
                    if (appinioSwiperController.cardIndex != 0) {
                      await appinioSwiperController.unswipe();
                    }
                  },
                  icon: Icon(
                    Icons.reply,
                    color: (appinioSwiperController.cardIndex == 0)
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.white,
                    size: 28,
                  ),
                ),
                IconButton(
                  focusNode: autoPlayFocus,
                  focusColor: Colors.grey,
                  onPressed: () async {
                    try {
                      setState(() {
                        isAutoPlay = !isAutoPlay;
                      });
                      while (appinioSwiperController.cardIndex! <=
                              widget.listCard.length - 1 &&
                          isAutoPlay) {
                        await Future.delayed(const Duration(seconds: 1));
                        if (appinioSwiperController.cardIndex! <
                            widget.listCard.length) {
                          await appinioSwiperController.swipeLeft();
                        }
                      }
                      setState(() {
                        isAutoPlay = false;
                        autoPlayFocus.unfocus();
                      });
                    } catch (e) {
                      print('error nè $e');
                    }
                  },
                  icon: Icon(
                    (isAutoPlay) ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
