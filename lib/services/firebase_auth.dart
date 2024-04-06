import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizletapp/models/user.dart';

class FirebaseAuthService {
  // Khai báo một static biến private để lưu trữ thể hiện duy nhất của lớp FirebaseAuthService
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  // Thuộc tính private để lưu trữ tham chiếu đến FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //đăng nhập với GG
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
      rethrow;
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
      rethrow;
    }
  }

  // đăng nhập bằng google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      return user;
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  //đăng ký bằng tài khoản google
  Future<UserCredential?> signUpWithGoogle() async {
    try {
      // Đăng nhập bằng Google
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuth =
          await googleSignInAccount!.authentication;

      // Tạo credential từ thông tin xác thực của Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken,
      );

      // Đăng ký vào Firebase với credential của Google
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Trả về thông tin người dùng
      return userCredential;
    } catch (error) {
      // Xử lý lỗi nếu có
      print('Error signing up with Google: $error');
      return null;
    }
  }

// Hàm đổi mật khẩu
  Future<String> changePassword(
      String currentPassword, String newPassword) async {
    try {
      // Lấy thông tin người dùng hiện tại
      User? user = getCurrentUser();

      // Xác thực mật khẩu hiện tại của người dùng
      final AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      // Nếu xác thực thành công, thực hiện quá trình đổi mật khẩu
      await user.updatePassword(newPassword);
      return '';
    } catch (e) {
      // Xử lý các lỗi
      print("Đổi mật khẩu thất bại: $e");
      return "Mật khẩu của bạn không đúng. Vui lòng thử lại!";
    }
  }

  // Phương thức để lấy thông tin người dùng hiện tại
  User? getCurrentUser() {
    try {
      return _auth.currentUser;
    } catch (error) {
      print('Error getting current user: $error');
      rethrow;
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
      rethrow;
    }
  }
}
