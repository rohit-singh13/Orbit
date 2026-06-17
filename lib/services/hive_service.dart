import 'package:hive/hive.dart';

class HiveService {
  static final Box userBox = Hive.box('userBox');

  static Future<void> saveProfileImagePath(String uid, String path) async {
    await userBox.put('profileImagePath_$uid', path);
  }

  static String? getProfileImagePath(String uid) {
    return userBox.get('profileImagePath_$uid');
  }
}