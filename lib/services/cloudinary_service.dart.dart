import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class StorageService {
  static const String _cloudName = 'dyuwjosck';
  static const String _uploadPreset = 'avatar_upload';

  Future<String> uploadAvatarBytes(
    Uint8List bytes, {
    String fileName = 'avatar.jpg',
  }) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: fileName),
      );

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Upload failed: $responseBody');
    }

    final data = json.decode(responseBody);
    return data['secure_url'];
  }
}
