import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizletapp/pages/intro_page.dart';
import '../enums/text_style_enum.dart';
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
  bool isLoading = false;

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
                      auth.signInWithGoogle();
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
            child: CircularProgressIndicator(),
          ),
        ),
    ]);
  }

  _createForgotNameOrPassWord() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Quên ",
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: "tên người dùng",
              style: const TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Hiển thị dialog khi nhấn vào "tên người dùng"
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Quên tên người dùng"),
                        content: const Text("Nội dung dialog"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Đóng"),
                          ),
                        ],
                      );
                    },
                  );
                },
            ),
            const TextSpan(
              text: " hoặc ",
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: "mật khẩu",
              style: const TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Hiển thị dialog khi nhấn vào "mật khẩu"
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Quên mật khẩu"),
                        content: const Text("Nội dung dialog"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Đóng"),
                          ),
                        ],
                      );
                    },
                  );
                },
            ),
            const TextSpan(
              text: "?",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      isObShowPassWord = !isObShowPassWord;
    });
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
                style: const TextStyle(color: Colors.black),
              ),
            );
          },
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      }
    }
  }
}
