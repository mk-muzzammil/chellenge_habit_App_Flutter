import 'package:chellenge_habit_app/utils/constants.dart';
import 'package:cloudinary/cloudinary.dart';

class CloudinaryService {
  final Cloudinary _cloudinary;

  CloudinaryService()
      : _cloudinary = Cloudinary.unsignedConfig(
          cloudName: AppConstants
              .cloudinaryCloudName, // Replace with your Cloudinary cloud name
        );

  Future<String?> uploadImage(String filePath, String uploadPreset,
      {String? fileName}) async {
    try {
      final response = await _cloudinary.unsignedUpload(
        file: filePath,
        uploadPreset: uploadPreset,
        fileName: fileName ??
            'uploaded_file_${DateTime.now().millisecondsSinceEpoch}',
        resourceType: CloudinaryResourceType.image,
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        print('Cloudinary upload error: ${response.error}');
        return null;
      }
    } catch (e) {
      print('Exception during upload: $e');
      return null;
    }
  }
}
