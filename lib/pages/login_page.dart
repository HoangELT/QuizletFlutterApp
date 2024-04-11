import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../enums/text_style_enum.dart';
import '../models/user.dart';
import '../services/firebase_auth.dart';
import '../services/shared_preferences_service.dart';
import '../utils/app_theme.dart';
import '../widgets/appbar_default.dart';
import '../widgets/elevatedButton.dart';
import '../widgets/text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuthService auth = FirebaseAuthService();
  String email = '';
  String passWord = '';
  bool isObShowPassWord = true;
  final formKey = GlobalKey<FormState>();
  var controllerForgorPw = TextEditingController();
  bool isLoading = false;
  bool isLoadings = false;

  @override
  void dispose() {
    controllerForgorPw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: AppTheme.primaryBackgroundColorAppbar,
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  CustomText(
                    text: "Đăng nhập nhanh bằng",
                    type: TextStyleEnum.large,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _googleSignIn(context);
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(52)),
                      backgroundColor: MaterialStateProperty.all(
                          AppTheme.primaryBackgroundColorAppbar),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                    label: CustomText(
                      text: "Tiếp tục với Google",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    text:
                        "hoặc đăng nhập bằng email hoặc tên người dùng của bạn",
                    type: TextStyleEnum.large,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onSaved: (newEmail) {
                      email = newEmail!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng nhập email hoặc tên người dùng của bạn";
                      }
                      if (!value.contains('@')) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      label: CustomText(
                          style: const TextStyle(color: Colors.white),
                          text: "Nhập email của bạn"),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Màu viền khi focus
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Màu viền khi có lỗi và focus
                      ),
                      errorStyle: const TextStyle(color: Colors.red),
                      focusColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    onSaved: (newPassWord) {
                      passWord = newPassWord!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng nhập mật khẩu của bạn";
                      }
                      // Kiểm tra độ dài mật khẩu
                      if (value.length < 7) {
                        return "Mật khẩu phải có ít nhất 7 ký tự";
                      }
                      if (value.length > 64) {
                        return "Mật khẩu phải ít hơn 64 ký tự";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      _submit();
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      label: CustomText(
                        text: "Nhập mật khẩu của bạn",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _togglePasswordVisibility();
                        },
                        icon: Icon(
                          isObShowPassWord
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Màu viền khi focus
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Màu viền khi có lỗi và focus
                      ),
                      errorStyle: const TextStyle(color: Colors.red),
                      focusColor: Colors.white,
                    ),
                    obscureText: isObShowPassWord,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 28),
                  _createForgotNameOrPassWord(),
                  const SizedBox(height: 28),
                  Center(
                      child: CustomText(
                          textAlign: TextAlign.center,
                          text:
                              "Bằng việc đăng nhập, bạn chấp nhận Điều khoản dịch vụ và Chính sách quyền riêng tư của Quizlet")),
                  const SizedBox(height: 28),
                  CustomElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      text: "Đăng nhập"),
                ],
              ),
            ),
          ),
        ),
      ),
      if (isLoading)
        Container(
          color: Colors.transparent.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
    ]);
  }

  _createForgotNameOrPassWord() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Bạn đã quên mật khẩu? ",
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: "Nhấn vào đây",
              style: const TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Hiển thị dialog khi nhấn vào "Click here"
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (context, setStateAlertDialog) {
                        return Stack(children: [
                          AlertDialog(
                            backgroundColor:
                                AppTheme.primaryBackgroundColorDiaLog,
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  CustomText(
                                    text: "Đặt lại mật khẩu",
                                    textAlign: TextAlign.center,
                                    type: TextStyleEnum.large,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomText(
                                    text:
                                        "Nhập địa chỉ email của bạn đã dùng để đăng ký. Chúng tôi sẽ email cho bạn một liên kết để đăng nhập và đặt lại mật khẩu",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  TextField(
                                    controller: controllerForgorPw,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      hintText: 'example@gmail.com',
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            actionsPadding: EdgeInsets.zero,
                            actions: [
                              Row(
                                children: [
                                  _createTextButton(
                                      "Hủy",
                                      const BorderRadius.only(
                                        bottomLeft: Radius.circular(28),
                                      ),
                                      const Border(
                                        top: BorderSide(
                                          color: Colors.grey,
                                          width: 0.8,
                                        ),
                                        right: BorderSide(
                                          color: Colors.grey,
                                          width: 0.8,
                                        ),
                                      ), () {
                                    Navigator.pop(context);
                                  }),
                                  _createTextButton(
                                      "OK",
                                      const BorderRadius.only(
                                        bottomRight: Radius.circular(28),
                                      ),
                                      const Border(
                                        top: BorderSide(
                                          color: Colors.grey,
                                          width: 0.8,
                                        ),
                                        left: BorderSide(
                                          color: Colors.grey,
                                          width: 0.8,
                                        ),
                                      ), () {
                                    _submitForgotPw(setStateAlertDialog);
                                  }),
                                ],
                              )
                            ],
                          ),
                          if (isLoadings)
                            Container(
                              color: Colors.transparent.withOpacity(0.5),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ]);
                      });
                    },
                  );
                },
            ),
          ],
        ),
      ),
    );
  }

  _createTextButton(String btnText, BorderRadiusGeometry border,
      BoxBorder boxBorder, void Function() onPressed) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: boxBorder,
          borderRadius: border,
        ),
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: border),
            ),
          ),
          child: CustomText(
            text: btnText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      isObShowPassWord = !isObShowPassWord;
    });
  }

  void _submitForgotPw(
      void Function(void Function()) setStateAlertDialog) async {
    try {
      String email = controllerForgorPw.text;
      setStateAlertDialog(() {
        isLoadings = true;
      });
      bool isCorrect = await auth.resetPassword(email);
      setStateAlertDialog(() {
        isLoadings = false;
      });
      Navigator.pop(context);
      if (isCorrect) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppTheme.primaryBackgroundColorDiaLog,
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomText(
                      text: "Đã gửi email",
                      textAlign: TextAlign.center,
                      type: TextStyleEnum.large,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text:
                          "Chúng tôi đã gửi mail đến $email. Vui lòng kiểm tra hòm thư để thay đổi mật khẩu của bạn.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: EdgeInsets.zero,
              actions: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: 0.8,
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  width: double.maxFinite,
                  height: 50.0,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent),
                          shape:
                              MaterialStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          )))),
                      child: CustomText(
                        text: "Ok",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      )),
                )
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 45,
              ),
              title: CustomText(
                text: 'Vui lòng nhập đúng địa chỉ email',
                type: TextStyleEnum.large,
              ),
              backgroundColor: AppTheme.primaryBackgroundColorAppbar,
            );
          },
        );

        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context, rootNavigator: true).pop();
      }
      controllerForgorPw.clear();
    } catch (e) {}
  }

  void _submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      try {
        setState(() {
          isLoading = true;
        });
        // Thực hiện xác thực từ Firebase
        var result = await auth.signInWithEmailAndPassword(email, passWord);
        setState(() {
          isLoading = false;
        });
        print(result);
        //lưu uid vào local sau khi đăng nhập thành công
        SharedPreferencesService().saveUID(result.user!.uid.toString());
        // Nếu xác thực thành công, thực hiện chuyển hướng đến app page và xóa hết các màn hình khác
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (route) => route.settings.name == '/');
      } catch (error) {
        // Xử lý khi có lỗi xác thực từ Firebase
        print('Error signing in: $error');
        setState(() {
          isLoading = false;
        });
        // Hiển thị alertDialog thông báo lỗi
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 45,
              ),
              title: CustomText(
                text: 'Sai email hoặc password. Vui lòng thử lại!',
                type: TextStyleEnum.large,
              ),
              backgroundColor: AppTheme.primaryBackgroundColorAppbar,
            );
          },
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  _googleSignIn(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      // Đăng nhập với GG
      var result = await auth.signInWithGoogle();
      print(result);
      if (result != null) {
        setState(() {
          isLoading = false;
        });
        //lưu uid vào local sau khi đăng nhập thành công
        SharedPreferencesService().saveUID(result.user!.uid.toString());
        // Nếu xác thực thành công, thực hiện chuyển hướng đến app page và xóa hết các màn hình khác
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (route) => route.settings.name == '/');
      }
    } catch (e) {}
  }
}
