import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

class LocalServer {
  static HttpServer? _server;
  static String? _serverUrl;

  /// Starts the local server and returns the URL string containing the local IP
  /// Example: http://192.168.1.15:8080/document.pdf
  static Future<String?> startServer(String assetPath) async {
    if (kIsWeb) {
      try {
        // On Web, we cannot start a local socket server (dart:io is unsupported).
        // However, the assets are already being served by the web server!
        // We can just construct the direct URL to the PDF file.
        final baseUrl = Uri.base.origin; // e.g. http://localhost:65444
        final path = Uri.base.path; // In case the app is hosted in a sub-folder
        
        // Remove trailing slash from path if it exists to avoid double slashes
        final cleanPath = path.endsWith('/') ? path.substring(0, path.length - 1) : path;
        
        // Flutter web serves assets inside an 'assets' directory. 
        // We must properly encode each segment to handle characters like '+' and spaces.
        final encodedAssetPath = assetPath
            .split('/')
            .map((segment) => Uri.encodeComponent(segment))
            .join('/');
            
        final webUrl = '$baseUrl$cleanPath/assets/$encodedAssetPath';
        return webUrl;
      } catch (e) {
        return null;
      }
    }

    if (_server != null) {
      await stopServer();
    }

    try {
      // Find an available port by using 0
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      
      // Handle incoming requests
      _server!.listen((HttpRequest request) async {
        if (request.uri.path == '/document.pdf') {
          try {
            // Load the asset
            final byteData = await rootBundle.load(assetPath);
            final buffer = byteData.buffer;
            final bytes = buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

            // Set headers for file download
            // Using application/pdf and inline allows mobile browsers (especially iOS Safari) 
            // to open the PDF natively, where the user can easily view and save it.
            request.response.headers.contentType = ContentType('application', 'pdf');
            request.response.headers.contentLength = bytes.length;
            
            // Allow cross-origin just in case
            request.response.headers.add('Access-Control-Allow-Origin', '*');
            
            // Clean up filename for the header to prevent browser parsing errors
            String fileName = assetPath.split('/').last;
            // Replace spaces and invalid characters with underscores
            fileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9.\-_]'), '_');
            if (!fileName.toLowerCase().endsWith('.pdf')) {
              fileName += '.pdf';
            }
            
            request.response.headers.add('Content-Disposition', 'inline; filename="$fileName"');
            
            if (request.method == 'HEAD') {
              await request.response.close();
              return;
            }
            
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
        
        // 1. Try to find a Wi-Fi or Ethernet interface first
        for (var interface in interfaces) {
          final name = interface.name.toLowerCase();
          if (name.contains('wlan') || name.contains('en') || name.contains('eth') || name.contains('ap')) {
            for (var addr in interface.addresses) {
              if (!addr.isLoopback) {
                localIP = addr.address;
                break;
              }
            }
          }
          if (localIP != null) break;
        }
        
        // 2. Fallback to any non-loopback interface
        if (localIP == null) {
          for (var interface in interfaces) {
            for (var addr in interface.addresses) {
              if (!addr.isLoopback) {
                localIP = addr.address;
                break;
              }
            }
            if (localIP != null) break;
          }
        }
      } catch (e) {
        // Fallback
      }
      
      if (localIP != null) {
        _serverUrl = 'http://$localIP:${_server!.port}/document.pdf';
        return _serverUrl;
      } else {
        // Fallback for emulator testing or if wifi IP fails
        _serverUrl = 'http://127.0.0.1:${_server!.port}/document.pdf';
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
