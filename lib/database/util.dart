import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kabadi/screens/landing_page.dart';
import 'package:kabadi/screens/navigationbar.dart';

class LoginController extends GetxController {
  late Rx<User?> _user;

  User? get user => _user.value;

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const NavigationBarWidget());
    } else {
      Get.offAll(() => const LandingPage());
    }
  }

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialScreen);
  }
}
