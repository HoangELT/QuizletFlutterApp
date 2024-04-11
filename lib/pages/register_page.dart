import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../enums/text_style_enum.dart';
import '../services/firebase_auth.dart';
import '../services/shared_preferences_service.dart';
import '../utils/app_theme.dart';
import '../widgets/appbar_default.dart';
import '../widgets/elevatedButton.dart';
import '../widgets/text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var isChecked = true;
  var selectedDate;
  bool isObShowPassWord = true;
  bool isObShowCfPassWord = true;
  FirebaseAuthService auth = FirebaseAuthService();
  String email = '';
  String passWord = '';
  String birthday = '';
  String cfPassWord = '';
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    focusNode.dispose();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Đăng ký nhanh bằng",
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
                    text: "hoặc tạo một tài khoản",
                    type: TextStyleEnum.large,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    // onSaved: (newBirthday) {
                    //   birthday = newBirthday!;
                    // },
                    textInputAction: TextInputAction.next,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng nhập ngày sinh của bạn";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.cake_outlined,
                        color: Colors.white,
                      ),
                      label: CustomText(text: "Nhập ngày sinh của bạn"),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Màu viền khi focus
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Màu viền khi có lỗi và focus
                      ),
                      focusColor: Colors.white,
                    ),
                    keyboardType: TextInputType.datetime,
                    style: const TextStyle(color: Colors.white),
                    onTap: () => _selectDate(context),
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                          : '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onSaved: (newEmail) {
                      email = newEmail!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng nhập email của bạn";
                      }
                      if (!value.contains('@')) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      ),
                      label: CustomText(text: "Nhập email của bạn"),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Màu viền khi focus
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Màu viền khi có lỗi và focus
                      ),
                      focusColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      focusNode.requestFocus();
                    },
                    onSaved: (newPassWord) {
                      passWord = newPassWord!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng nhập mật khẩu";
                      }
                      // Kiểm tra độ dài mật khẩu
                      if (value.length < 7) {
                        return "Mật khẩu phải có ít nhất 7 ký tự";
                      }
                      if (value.length > 64) {
                        return "Mật khẩu phải ít hơn 64 ký tự";
                      }
                      // Kiểm tra xem mật khẩu có chứa ít nhất một ký tự hoa không
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return "Mật khẩu phải chứa ít nhất một ký tự hoa";
                      }
                      // Kiểm tra xem mật khẩu có chứa ít nhất một ký tự thường không
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return "Mật khẩu phải chứa ít nhất một ký tự thường";
                      }
                      // Kiểm tra xem mật khẩu có chứa ít nhất một ký tự đặc biệt không
                      if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                        return "Mật khẩu phải chứa ít nhất một ký tự đặc biệt";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          _ShowPassword();
                        },
                        icon: Icon(
                          isObShowPassWord
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white,
                      ),
                      label: CustomText(text: "Tạo mật khẩu của bạn"),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Màu viền khi focus
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Màu viền khi có lỗi và focus
                      ),
                      focusColor: Colors.white,
                    ),
                    obscureText: isObShowPassWord,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    focusNode: focusNode,
                    onSaved: (newCfPassWord) {
                      cfPassWord = newCfPassWord!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng xác nhận mật khẩu của bạn";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      _submit();
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          _CfShowPassword();
                        },
                        icon: Icon(
                          isObShowCfPassWord
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_reset_sharp,
                        color: Colors.white,
                      ),
                      label: CustomText(text: "Xác nhận lại mật khẩu của bạn"),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Màu viền khi focus
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Màu viền khi có lỗi và focus
                      ),
                      focusColor: Colors.white,
                    ),
                    obscureText: isObShowCfPassWord,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Center(
                      child: CustomText(
                          textAlign: TextAlign.center,
                          text:
                              "Bằng việc đăng ký, bạn chấp nhận Điều khoản dịch vụ và Chính sách quyền riêng tư của Quizlet")),
                  const SizedBox(height: 28),
                  CustomElevatedButton(
                    text: "Đăng ký",
                    onPressed: () {
                      _submit();
                    },
                  )
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

  void _ShowPassword() {
    setState(() {
      isObShowPassWord = !isObShowPassWord;
    });
  }

  void _CfShowPassword() {
    setState(() {
      isObShowCfPassWord = !isObShowCfPassWord;
    });
  }

  void _submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      if (cfPassWord == passWord) {
        try {
          setState(() {
            isLoading = true;
          });
          // Thực hiện xác thực từ Firebase
          await auth.signUpWithEmailAndPassword(email, passWord);
          setState(() {
            isLoading = false;
          });
          _showDialog("Đăng ký thành công", Icons.check_circle_outline_outlined,
              Colors.green);
        } catch (error) {
          // Xử lý khi có lỗi xác thực từ Firebase
          print('Error signing up: $error');
          setState(() {
            isLoading = false;
          });
          // Hiển thị AlertDialog thông báo lỗi
          _showDialog('Đăng ký thất bại. Vui lòng thử lại!',
              Icons.warning_amber_rounded, Colors.red);
        }
      }
    }
  }

  _showDialog(String text, IconData ic, Color color) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            ic,
            color: color,
            size: 45,
          ),
          title: CustomText(
            text: text,
            type: TextStyleEnum.large,
          ),
          backgroundColor: AppTheme.primaryBackgroundColorAppbar,
        );
      },
    );
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context, rootNavigator: true).pop();

    if (text == "Đăng ký thành công") {
      // Nếu đăng ký thành công, thực hiện chuyển hướng đến trang login
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
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
