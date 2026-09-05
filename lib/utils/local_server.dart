class LocalServer {
  /// Generates the direct download URL for the PDF using your public GitHub repository!
  /// This requires ZERO servers, ZERO temp files, and works everywhere in the world instantly!
  static Future<String?> startServer(String assetPath) async {
    try {
      // 1. Your GitHub repository raw content base URL
      const String githubRawBaseUrl = 'https://raw.githubusercontent.com/mayurranshinge08/qrcode/main/';
      
      // 2. Properly encode the file path segments (to handle spaces and '+' signs)
      final encodedAssetPath = assetPath
          .split('/')
          .map((segment) => Uri.encodeComponent(segment))
          .join('/');
          
      // 3. Construct the direct global internet URL
      final globalUrl = '$githubRawBaseUrl$encodedAssetPath';
      
      return globalUrl;
    } catch (e) {
      print('Error generating GitHub URL: $e');
      return null;
    }
  }

  static Future<void> stopServer() async {
    // No longer needed!
  }
}
