import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageUploadService {

  static const cloudName = "YOUR_CLOUD_NAME";
  static const uploadPreset = "YOUR_UPLOAD_PRESET";

  static Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest("POST", url);

    request.fields['upload_preset'] = uploadPreset;
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final response = await request.send();
    final resData = await response.stream.bytesToString();

    final data = jsonDecode(resData);

    if (response.statusCode == 200) {
      return data['secure_url'];
    } else {
      return null;
    }
  }
}