import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enums/text_style_enum.dart';
import '../utils/app_theme.dart';
import '../widgets/text.dart';

class ChangePassWord extends StatefulWidget {
  const ChangePassWord({super.key});

  @override
  State<ChangePassWord> createState() => _ChangePassWordState();
}

class _ChangePassWordState extends State<ChangePassWord> {
  var flag = false;
  var formKey = GlobalKey<FormState>();
  String oldPassWord = '';
  String newPassWord = '';
  String confirmPassWord = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: AppTheme.primaryBackgroundColor,
        title: CustomText(
          text: "Đổi mật khẩu",
          type: TextStyleEnum.large,
        ),
        actions: [
          TextButton(
              onPressed: flag
                  ? () {
                      print("object");
                    }
                  : null,
              child: CustomText(
                text: "Lưu",
                type: TextStyleEnum.large,
                style: TextStyle(
                  color: flag ? Colors.white : Colors.grey,
                ),
              )),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (oldPassWord) {
                  oldPassWord = oldPassWord!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng mật khẩu của bạn";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: CustomText(
                    text: "Nhập mật khẩu hiện tại",
                    style: const TextStyle(color: Colors.white),
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
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onSaved: (newPassWord) {
                  newPassWord = newPassWord!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng mật khẩu của bạn";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: CustomText(
                    text: "Nhập mật khẩu mới",
                    style: const TextStyle(color: Colors.white),
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
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onSaved: (cfNewPassWord) {
                  confirmPassWord = cfNewPassWord!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng mật khẩu của bạn";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: CustomText(
                    text: "Xác nhận mật khẩu mới",
                    style: const TextStyle(color: Colors.white),
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
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      try {
        // Thực hiện xác thực từ Firebase
        //await auth.signInWithEmailAndPassword(email, passWord);
        // Nếu xác thực thành công, thực hiện chuyển hướng đến app page
        Navigator.pushReplacementNamed(context, "/app");
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
