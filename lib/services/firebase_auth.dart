import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  // Khai báo một static biến private để lưu trữ thể hiện duy nhất của lớp FirebaseAuthService
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  // Thuộc tính private để lưu trữ tham chiếu đến FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hàm factory để trả về thể hiện duy nhất của lớp FirebaseAuthService
  factory FirebaseAuthService() {
    return _instance;
  }

  // Constructor private
  FirebaseAuthService._internal();

  // Phương thức để đăng nhập bằng email và mật khẩu
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } catch (error) {
      print('Error signing in: $error');
      throw error;
    }
  }

  // Phương thức để đăng ký một tài khoản mới bằng email và mật khẩu
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (error) {
      print('Error signing up: $error');
      throw error;
    }
  }

  // Phương thức để lấy thông tin người dùng hiện tại
  User? getCurrentUser() {
    try {
      return _auth.currentUser;
    } catch (error) {
      print('Error getting current user: $error');
      throw error;
    }
  }

  // Phương thức để kiểm tra xem người dùng đã đăng nhập hay chưa
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  // Phương thức để đăng xuất người dùng
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print('Error signing out: $error');
      throw error;
    }
  }
}
