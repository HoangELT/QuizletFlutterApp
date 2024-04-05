import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../enums/text_style_enum.dart';
import '../services/firebase_auth.dart';
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
  FirebaseAuthService auth = FirebaseAuthService();
  var controllerEmail = TextEditingController();
  var controllerPw = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    controllerPw.dispose();
    controllerEmail.dispose();
  }

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
                CustomText(
                  text: "Đăng ký nhanh bằng",
                  type: TextStyleEnum.large,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    auth.signUpWithGoogle();
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng nhập ngày sinh của bạn";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: CustomText(
                        style: const TextStyle(color: Colors.grey),
                        text: "Nhập ngày sinh của bạn"),
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
                  onTap: () => _selectDate(context),
                  controller: TextEditingController(
                    text: selectedDate != null
                        ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                        : '',
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: controllerEmail,
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
                    label: CustomText(
                        style: const TextStyle(color: Colors.grey),
                        text: "Nhập email của bạn"),
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
                  controller: controllerPw,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng nhập mật khẩu";
                    }
                    // Kiểm tra độ dài mật khẩu
                    if (value.length < 7) {
                      return "Mật khẩu phải có ít nhất 7 ký tự";
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
                    label: CustomText(
                      text: "Tạo mật khẩu của bạn",
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
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "Bạn là giáo viên?"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            activeColor: Colors.white,
                            checkColor: Colors.grey,
                            side: const BorderSide(color: Colors.white),
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            }),
                        CustomText(text: "Phải"),
                        Checkbox(
                            activeColor: Colors.white,
                            checkColor: Colors.grey,
                            side: const BorderSide(color: Colors.white),
                            value: !isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = !value!;
                              });
                            }),
                        CustomText(text: "Không"),
                      ],
                    )
                  ],
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
    );
  }

  void _submit() async {
    if (formKey.currentState!.validate()) {
      try {
        // Thực hiện xác thực từ Firebase
        await auth.signUpWithEmailAndPassword(
            controllerEmail.text, controllerPw.text);
        // Nếu đăng ký thành công, thực hiện chuyển hướng đến trang login
        Navigator.pushReplacementNamed(context, "/login");
        
      } catch (error) {
        // Xử lý khi có lỗi xác thực từ Firebase
        print('Error signing in: $error');

        // Hiển thị Snackbar thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: CustomText(text: 'Đăng ký thất bại. Vui lòng thử lại.')),
        );
      }
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
}
