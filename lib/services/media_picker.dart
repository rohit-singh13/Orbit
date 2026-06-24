import 'package:image_picker/image_picker.dart';
import 'package:orbit/services/hive_service.dart';
import 'package:orbit/providers/user_provider.dart';

class MediaPicker {
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(UserProvider userProvider) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null) {
      await HiveService.saveProfileImagePath(
        userProvider.user!.uid,
        image.path
      );
      userProvider.setImagePath(image.path);
    }
  }

  Future<List<String>> pickMultipleImages() async {
    final List<XFile> images = await picker.pickMultiImage();
    return images.map((image) => image.path).toList();
  }

  Future<String?> pickStoryImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }
}