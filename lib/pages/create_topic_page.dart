import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/models/card.dart'; // Changed from 'package:quizletapp/models/card.dart';
import 'package:quizletapp/models/topic.dart';
import 'package:quizletapp/models/user.dart';
import 'package:quizletapp/pages/topic_setting.dart';
import 'package:quizletapp/services/firebase_auth.dart';
import 'package:quizletapp/services/provider/topic_provider.dart';
import 'package:quizletapp/services/models_services/topic_service.dart';
import 'package:quizletapp/utils/app_theme.dart';
import 'package:quizletapp/widgets/group_field_card.dart';
import 'package:quizletapp/widgets/loading.dart';
import 'package:quizletapp/widgets/text.dart';
import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CreateTopicPage extends StatefulWidget {
  const CreateTopicPage({Key? key}) : super(key: key);

  @override
  State<CreateTopicPage> createState() => _CreateTopicPageState();
}

class _CreateTopicPageState extends State<CreateTopicPage> {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  bool isLoading = false;

  bool isPublic = true;

  var uuid = Uuid();

  List<CardModel> listCard = [];

  List<FocusNode> listFocus = [];

  var viewCards = [];

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    listCard.add(CardModel(uuid.v4(), '', ''));
    listCard.add(CardModel(uuid.v4(), '', ''));
    listCard.add(CardModel(uuid.v4(), '', ''));

    listFocus.add(FocusNode());
    listFocus.add(FocusNode());
    listFocus.add(FocusNode());
    listFocus.add(FocusNode());
    listFocus.add(FocusNode());
    listFocus.add(FocusNode());
    listFocus[0].requestFocus();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (FocusNode i in listFocus) {
      i.dispose();
    }
    super.dispose();
  }

  int? getIndexFocus() {
    int index = 0;
    for (int i = 0; i < listFocus.length; i++) {
      if (listFocus[i].hasFocus) {
        return i;
      }
    }
    return null;
  }

  void _addNewCard() {
    int? index = getIndexFocus();
    if (listFocus.length % 2 == 0) {
      FocusNode termFocus = FocusNode();
      FocusNode defineFocus = FocusNode();

      setState(() {
        listFocus.add(termFocus);
        listFocus.add(defineFocus);

        listCard.add(CardModel(uuid.v4(), '', ''));
      });

      termFocus.requestFocus();

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void _deleteCard(int index, CardModel cardModel, FocusNode focusNode1,
      FocusNode focusNode2) {
    if (listCard.length > 0) {
      setState(() {
        // listCard.removeAt(index);
        // listFocus.removeRange(index * 2, index * 2 + 2);
        listCard.remove(cardModel);
        listFocus.remove(focusNode1);
        listFocus.remove(focusNode2);
      });
    }
  }

  String? _checkValue() {
    if (listCard.length < 3) {
      return 'Bạn phải thêm vào ít nhất hai thuật ngữ mới lưu được học phần.';
    }
    int count = 0;
    for (int i = 1; i < listCard.length; i++) {
      String term = listCard[i].term;
      String define = listCard[i].define;
      if (term.isNotEmpty || define.isNotEmpty) {
        count++;
      }
    }
    if (count < 2) {
      if (count == 0 && listCard[0].term.isEmpty) return 'not create';
      return 'Bạn phải thêm vào ít nhất hai thuật ngữ mới lưu được học phần.';
    }
    if (listCard[0].term.isEmpty) {
      return 'Bạn phải nhập tiêu đề mới lưu được học phần này';
    }
    return null;
  }

  List<CardModel> listCardCleaned(List<CardModel> list) {
    List<CardModel> listResult = [];
    for(var i in list){
      if(i.term.isNotEmpty || i.define.isNotEmpty)
        listResult.add(i);
    }
    return listResult;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
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
              onPressed: () async {
                //Cài đặt topic
                var prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isPublic', isPublic);
                var rs = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicSettingPage(
                      isPublic: isPublic,
                    ),
                  ),
                );
                var public = await prefs.getBool('isPublic') ?? true;
                setState(() {
                  isPublic = public;
                });
              },
              icon: const Icon(Icons.settings_outlined),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    // FocusScope.of(context).unfocus();
                    String? resultCheck = _checkValue();
                    if (resultCheck == null) {
                      //Đã check thông tin thành công
                      //lưu vào db
                      CardModel titleAndDes = listCard[0];
                      print(
                          'Tiêu đề: ${titleAndDes.term}, Mô tả: ${titleAndDes.define}');
                      if (listCard.isNotEmpty) {
                        TopicService topicService = TopicService();

                        var listClone = listCard.sublist(1);
                        List<CardModel> newListCard = listCardCleaned(listClone);
                        //in ra check
                        print('Danh sách thẻ sau khi thêm mới:');
                        for (CardModel card in newListCard) {
                          print(
                              'Thuật ngữ: ${card.term}, Định nghĩa: ${card.define}');
                        }

                        //lưu
                        var user = firebaseAuthService.getCurrentUser();
                        if (user != null) {
                          TopicModel newTopic = TopicModel(
                              user.uid,
                              user.displayName!,
                              uuid.v4(),
                              titleAndDes.term,
                              titleAndDes.define,
                              isPublic,
                              newListCard);
                          setState(() {
                            isLoading = true;
                          });
                          await topicService.addTopic(newTopic);
                          setState(() {
                            isLoading = false;
                          });
                          print('Tạo topic thành công');
                          context.read<TopicProvider>().reloadListTopic();
                        }
                        Navigator.pop(context, 201);
                      }
                      else
                      {
                        print('listCard rỗng');
                      }
                    } else if (resultCheck.compareTo('not create') == 0) {
                      //chưa điền gì nên không lưu
                      Navigator.pop(context);
                    } else {
                      var code = await showModalBottomSheet(
                        backgroundColor: const Color.fromARGB(255, 44, 63, 79),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  width: 44,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        160, 127, 144, 155),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 12,
                                  ),
                                  child: CustomText(
                                    text: resultCheck,
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // Divider(
                                //   height: 0.05,
                                //   color: Colors.grey.withOpacity(0.5),
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     Navigator.pop(context, 0);
                                //   },
                                //   child: Container(
                                //     height: 52,
                                //     decoration: BoxDecoration(
                                //       color: Colors.transparent,
                                //       borderRadius: BorderRadius.circular(8),
                                //       border: Border.all(color: Colors.transparent),
                                //     ),
                                //     child: Center(
                                //       child: CustomText(
                                //         text: 'Lưu nháp',
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.w400,
                                //             fontSize: 20),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Divider(
                                  height: 0.05,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context, 1);
                                  },
                                  child: Container(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.transparent),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        text: 'Xóa học phần này',
                                        type: TextStyleEnum.large,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromARGB(255, 249, 15, 11),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0.05,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context, 2);
                                  },
                                  child: Container(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.transparent),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        text: 'Hủy',
                                        type: TextStyleEnum.large,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0.05,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                      if (code != null) {
                        if (code == 0) {
                          //lưu nháp
                          Navigator.pop(context);
                        } else if (code == 1) {
                          //xóa học phần đang tạo
                          var isDelete = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(159, 33, 38, 40),
                                actionsAlignment: MainAxisAlignment.center,
                                title: CustomText(
                                  text:
                                      'Bạn có chắc chắn muốn xóa học phần này?',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      Navigator.pop(context, 0);
                                    },
                                    child: Container(
                                      height: 44,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          text: 'Hủy',
                                          type: TextStyleEnum.large,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      Navigator.pop(context, 1);
                                    },
                                    child: Container(
                                      height: 44,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          text: 'Xóa',
                                          type: TextStyleEnum.large,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(
                                                255, 249, 15, 11),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                          if (isDelete != null && isDelete == 1) {
                            //Xác nhận xóa
                            Navigator.pop(context);
                          }
                        }
                      }
                    }
                  } catch (e) {
                    print('Lỗi lưu topic vào database: $e');
                  }
                },
                child: CustomText(
                  text: 'Xong',
                  type: TextStyleEnum.large,
                ),
              ),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.only(bottom: 60),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 200),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              TextFormField(
                                initialValue: listCard[0].term,
                                focusNode: listFocus[0],
                                onChanged: (value) {
                                  listCard[index].term = value ?? '';
                                },
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Chủ đề, chương, đơn vị',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 4.0, color: Colors.white),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.white),
                                  ),
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
                            ],
                          ),
                          Wrap(
                            children: [
                              TextFormField(
                                initialValue: listCard[0].define,
                                focusNode: listFocus[1],
                                onChanged: (value) {
                                  listCard[index].define = value ?? '';
                                },
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Học phần của bạn có chủ đề gì?',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 4.0, color: Colors.white),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: 'Mô tả',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                            onPressed: () {
                              print('quét tài liệu');
                            },
                            child: Wrap(
                              spacing: 4,
                              children: [
                                const Icon(
                                  Icons.document_scanner_rounded,
                                  color: Color.fromARGB(255, 168, 129, 232),
                                ),
                                CustomText(
                                  text: 'Quét tài liệu',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 168, 129, 232),
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Dismissible(
                    key: ValueKey<String>(listCard[index].cardId),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      _deleteCard(index, listCard[index], listFocus[index * 2],
                          listFocus[index * 2 + 1]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: AppTheme.primaryBackgroundColorAppbar,
                      child: Column(
                        children: [
                          Wrap(
                            children: [
                              TextFormField(
                                initialValue: listCard[index].term,
                                focusNode: listFocus[index * 2],
                                onChanged: (value) {
                                  listCard[index].term = value ?? '';
                                },
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 4.0, color: Colors.white),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: 'Thuật ngữ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              TextFormField(
                                initialValue: listCard[index].define,
                                focusNode: listFocus[index * 2 + 1],
                                onChanged: (value) {
                                  listCard[index].define = value ?? '';
                                },
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 4.0, color: Colors.white),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: 'Định nghĩa',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                itemCount: listCard.length),
          ),
          bottomSheet: CupertinoInputAccessory(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                  color: AppTheme.primaryBackgroundColorAppbar,
                  border: Border(
                    top: BorderSide(
                      width: 0.5,
                      color: Colors.white,
                    ),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 64,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        var indexFocus = getIndexFocus();
                        if (indexFocus != null &&
                            indexFocus != (listFocus.length - 1)) {
                          listFocus[indexFocus + 1].requestFocus();
                        }
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    child: Material(
                      elevation: 4,
                      shape: const CircleBorder(),
                      color: AppTheme.primaryColor,
                      child: IconButton(
                        onPressed: () {
                          _addNewCard();
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 64,
                  )
                ],
              ),
            ),
          ),
        ),
        if (isLoading) const Loading(),
      ],
    );
  }
}
