import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class LocalServer {
  /// Uploads the asset to tmpfiles.org and returns the direct download URL
  /// This completely replaces the local socket server logic to allow the QR
  /// code to work anywhere, on any network, securely using a temp file host.
  static Future<String?> startServer(String assetPath) async {
    try {
      // 1. Load the asset bytes from the app bundle
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;
      final bytes = buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      // Extract original filename for the upload
      String fileName = assetPath.split('/').last;

      // 2. Create a multipart request to tmpfiles.org
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://tmpfiles.org/api/v1/upload'),
      );

      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: fileName),
      );

      // 3. Send request and wait for the upload to complete
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);

        if (jsonResponse['status'] == 'success') {
          // The API returns a view URL (e.g., https://tmpfiles.org/12345/file.pdf)
          // We must change it to the direct download URL by adding /dl/
          String viewUrl = jsonResponse['data']['url'];
          String directUrl = viewUrl.replaceFirst(
            'tmpfiles.org/',
            'tmpfiles.org/dl/',
          );
          return directUrl;
        }
      }
      return null;
    } catch (e) {
      print('Error uploading to tmpfiles.org: $e');
      return null;
    }
  }

  static Future<void> stopServer() async {
    // No longer needed because we don't host a local socket server anymore.
    // The tmpfiles.org service will automatically delete the file after some time.
  }
}
