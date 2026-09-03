import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class LocalServer {
  static HttpServer? _server;
  static String? _serverUrl;

  /// Starts the local server and returns the URL string containing the local IP
  /// Example: http://192.168.1.15:8080/download
  static Future<String?> startServer(String assetPath) async {
    if (_server != null) {
      await stopServer();
    }

    try {
      // Find an available port by using 0
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      
      // Handle incoming requests
      _server!.listen((HttpRequest request) async {
        if (request.uri.path == '/download') {
          try {
            // Load the asset
            final byteData = await rootBundle.load(assetPath);
            final buffer = byteData.buffer;
            final bytes = buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

            // Set headers for file download
            request.response.headers.contentType = ContentType('application', 'pdf');
            final fileName = assetPath.split('/').last;
            request.response.headers.add('Content-Disposition', 'attachment; filename="$fileName"');
            
            // Write the file bytes
            request.response.add(bytes);
            await request.response.close();
          } catch (e) {
            request.response.statusCode = HttpStatus.notFound;
            request.response.write('File not found');
            await request.response.close();
          }
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write('Not found');
          await request.response.close();
        }
      });

      // Get the local IP address using dart:io NetworkInterface
      String? localIP;
      try {
        final interfaces = await NetworkInterface.list(
          type: InternetAddressType.IPv4, 
          includeLinkLocal: true,
        );
        for (var interface in interfaces) {
          for (var addr in interface.addresses) {
            if (!addr.isLoopback) {
              localIP = addr.address;
              break; // get first non-loopback
            }
          }
          if (localIP != null) break;
        }
      } catch (e) {
        // Fallback
      }
      
      if (localIP != null) {
        _serverUrl = 'http://$localIP:${_server!.port}/download';
        return _serverUrl;
      } else {
        // Fallback for emulator testing or if wifi IP fails
        _serverUrl = 'http://127.0.0.1:${_server!.port}/download';
        return _serverUrl;
      }
    } catch (e) {
      // It failed to bind or something else
      return null;
    }
  }

  static Future<void> stopServer() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      _serverUrl = null;
    }
  }
}
