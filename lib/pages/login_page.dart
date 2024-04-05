import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../enums/text_style_enum.dart';
import '../services/firebase_auth.dart';
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
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColorAppbar,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Form(
            key: formKey,
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
                  text: "hoặc đăng nhập bằng email hoặc tên người dùng của bạn",
                  type: TextStyleEnum.large,
                ),
                const SizedBox(height: 16),
                TextFormField(
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
                    label: CustomText(
                        style: const TextStyle(color: Colors.grey),
                        text: "Nhập email hoặc tên người dùng của bạn"),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white), // Màu viền khi focus
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
                  onSaved: (newPassWord) {
                    passWord = newPassWord!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng mật khẩu của bạn";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: CustomText(
                      text: "Nhập mật khẩu của bạn",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white), // Màu viền khi focus
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red), // Màu viền khi có lỗi và focus
                    ),
                    errorStyle: const TextStyle(color: Colors.red),
                    focusColor: Colors.white,
                  ),
                  //keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
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
    );
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

  void _submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      try {
        // Thực hiện xác thực từ Firebase
        await auth.signInWithEmailAndPassword(email, passWord);
        // Nếu xác thực thành công, thực hiện chuyển hướng đến app page
        Navigator.pushReplacementNamed(context, "/app");
        Navigator.of(context)
            .popUntil((route) => route.settings.name != "/intro");
      } catch (error) {
        // Xử lý khi có lỗi xác thực từ Firebase
        print('Error signing in: $error');

        // Hiển thị Snackbar thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  CustomText(text: 'Đăng nhập thất bại. Vui lòng thử lại.')),
        );
      }
    }
  }
}
