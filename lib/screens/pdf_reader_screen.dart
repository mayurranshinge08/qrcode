import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/document.dart';
import '../utils/local_server.dart';
import '../widgets/qr_dialog.dart';

class PdfReaderScreen extends StatefulWidget {
  final PdfDocumentItem document;

  const PdfReaderScreen({super.key, required this.document});

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  bool _isGeneratingQr = false;

  /// Exact PDF asset path
  String get _pdfAssetPath {
    return 'assets/pdfs/${widget.document.fileName}';
  }

  @override
  void initState() {
    super.initState();

    // Check which PDF is actually being opened.
    debugPrint('-----------------------------------');
    debugPrint('PDF TITLE: ${widget.document.title}');
    debugPrint('PDF FILE: ${widget.document.fileName}');
    debugPrint('PDF PATH: $_pdfAssetPath');
    debugPrint('-----------------------------------');
  }

  /// Generate QR code for the selected PDF
  Future<void> _showQrCode() async {
    if (_isGeneratingQr) return;

    setState(() {
      _isGeneratingQr = true;
    });

    try {
      final serverUrl = await LocalServer.startServer(_pdfAssetPath);

      if (!mounted) return;

      setState(() {
        _isGeneratingQr = false;
      });

      if (serverUrl != null && serverUrl.isNotEmpty) {
        await showDialog(
          context: context,
          builder: (context) {
            return QrDialog(qrData: serverUrl);
          },
        );

        // Stop local server after QR dialog closes.
        LocalServer.stopServer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate PDF QR code.')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isGeneratingQr = false;
      });

      debugPrint('QR Error: $e');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to generate QR code: $e')));
    }
  }

  /// Back to previous screen
  void _goBack() {
    Navigator.of(context).pop();
  }

  /// Go to PDF document list
  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(
          widget.document.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      ),

      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.asset(
              _pdfAssetPath,

              // PDF viewer settings
              canShowScrollHead: true,
              canShowScrollStatus: true,
              canShowPaginationDialog: true,
              pageLayoutMode: PdfPageLayoutMode.continuous,
              enableDoubleTapZooming: true,

              // IMPORTANT:
              // This tells us if Flutter cannot load the actual PDF.
              onDocumentLoadFailed: (details) {
                debugPrint('PDF LOAD FAILED: ${details.description}');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'PDF could not be loaded: ${details.description}',
                    ),
                  ),
                );
              },

              onDocumentLoaded: (details) {
                debugPrint(
                  'PDF LOADED SUCCESSFULLY: ${widget.document.fileName}',
                );

                debugPrint('PAGE COUNT: ${details.document.pages.count}');
              },
            ),
          ),
        ],
      ),

      // Back + Home + QR Code in ONE ROW
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(0, -2),
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // BACK
              Expanded(
                child: TextButton.icon(
                  onPressed: _goBack,
                  icon: const Icon(CupertinoIcons.back),
                  label: const Text('Back'),
                ),
              ),

              // HOME
              Expanded(
                child: TextButton.icon(
                  onPressed: _goHome,
                  icon: const Icon(CupertinoIcons.home),
                  label: const Text('Home'),
                ),
              ),

              // QR CODE
              Expanded(
                child: TextButton.icon(
                  onPressed: _isGeneratingQr ? null : _showQrCode,
                  icon: _isGeneratingQr
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(CupertinoIcons.qrcode),
                  label: Text(_isGeneratingQr ? 'Loading' : 'QR Code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
