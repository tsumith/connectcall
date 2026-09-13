import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final int zegoAppId = int.parse(dotenv.env['ZEG0_APP_ID'] ?? '0');
  static final String zegoAppSign = dotenv.env['ZEG0_APP_SIGN'] ?? '';

  // Firestore Collection Names
  static const String usersCollection = 'users';
  static const String callsCollection = 'calls';

  // Typography
  static const String primaryFontFamily = 'Inter';

  // Cloudinary Configuration
  static final String cloudinaryCloudName =
      dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static final String cloudinaryUploadPreset =
      dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
}
