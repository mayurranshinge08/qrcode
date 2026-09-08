import 'package:flutter/foundation.dart';

class LocalServer {
  static Future<String?> startServer(String assetPath) async {
    debugPrint('========== LOCAL SERVER DEBUG ==========');
    debugPrint('1. startServer called with assetPath: $assetPath');
    
    try {
      // Base URL for raw GitHub content
      const String githubRawBaseUrl = 'https://raw.githubusercontent.com/mayurranshinge08/qrcode/main/';
      
      // Encode the file path segments to handle spaces and special characters like '+'
      final encodedAssetPath = assetPath
          .split('/')
          .map((segment) => Uri.encodeComponent(segment))
          .join('/');
          
      debugPrint('2. Encoded asset path: $encodedAssetPath');
          
      // Construct the direct raw GitHub URL
      final globalUrl = '$githubRawBaseUrl$encodedAssetPath';
      
      debugPrint('3. Final GitHub URL generated: $globalUrl');
      debugPrint('========================================');
      
      return globalUrl;
    } catch (e) {
      debugPrint('Error generating GitHub URL: $e');
      return null;
    }
  }

  static Future<void> stopServer() async {
    debugPrint('LocalServer.stopServer called (No-op for GitHub URLs)');
  }
}
