import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic(
      'djqprra64',
      'orbit_posts',
    cache: false
  );

  Future<String?> uploadImage(String imagePath) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print("Cloudinary Upload Error: $e");
      return null;
    }
  }

  Future<List<String>> uploadImages(
      List<String> imagePaths
      ) async {
    List<String> urls = [];
    for(String imagePath in imagePaths) {
      final String? url = await uploadImage(imagePath);
      if(url != null) {
        urls.add(url);
      }
    }
    return urls;
  }
}