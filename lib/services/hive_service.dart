import 'package:hive/hive.dart';

class HiveService {
  static final Box userBox = Hive.box('userBox');

  static Future<void> saveProfileImagePath(String path) async {
    await userBox.put('profileImagePath', path);
  }

  static String? getProfileImagePath() {
    return userBox.get('profileImagePath');
  }
}