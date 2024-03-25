import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

Rx<User?> user = Rx<User?>(null);
Rx<String> userRole = "".obs;
Rx<Map<String, dynamic>> userProfile = Rx<Map<String, dynamic>>({});
