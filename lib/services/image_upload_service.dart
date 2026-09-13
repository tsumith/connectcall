import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';

final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  return ImageUploadService();
});

class ImageUploadService {
  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/${AppConstants.cloudinaryCloudName}/image/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = AppConstants.cloudinaryUploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final json = jsonDecode(responseData);
        return json['secure_url'];
      } else {
        final error = await response.stream.bytesToString();
        throw Exception('Upload failed: $error');
      }
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }
}
