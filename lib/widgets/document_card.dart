import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/document.dart';
import '../theme/app_theme.dart';
import '../utils/local_server.dart';
import 'qr_dialog.dart';

class DocumentCard extends StatefulWidget {
  final PdfDocumentItem document;
  final VoidCallback onTap;

  const DocumentCard({super.key, required this.document, required this.onTap});

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  bool _isHovering = false;
  bool _isGeneratingQr = false;

  void _showQrDialog(BuildContext context) async {
    setState(() => _isGeneratingQr = true);
    final assetPath = 'assets/pdfs/${widget.document.fileName}';

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final serverUrl = await LocalServer.startServer(assetPath);

    if (!mounted) return;
    setState(() => _isGeneratingQr = false);

    if (serverUrl != null) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) => QrDialog(qrData: serverUrl),
      ).then((_) {
        LocalServer.stopServer();
      });
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Failed to generate offline link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, _isHovering ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 10,
                      //     vertical: 4,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: AppTheme.background,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Text(
                      //     'FEATURED',
                      //     style: Theme.of(context).textTheme.bodySmall
                      //         ?.copyWith(
                      //           fontSize: 10,
                      //           letterSpacing: 1,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //   ),
                      // ),
                      // IconButton(
                      //   onPressed: _isGeneratingQr
                      //       ? null
                      //       : () => _showQrDialog(context),
                      //   icon: _isGeneratingQr
                      //       ? const SizedBox(
                      //           width: 16,
                      //           height: 16,
                      //           child: CircularProgressIndicator(
                      //             strokeWidth: 2,
                      //           ),
                      //         )
                      //       : const Icon(CupertinoIcons.qrcode),
                      //   color: AppTheme.muted,
                      //   tooltip: 'Show QR Code',
                      //   visualDensity: VisualDensity.compact,
                      //   style: IconButton.styleFrom(
                      //     backgroundColor: AppTheme.background,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.doc,
                              size: 40,
                              color: AppTheme.primary,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'PDF DOCUMENT',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.document.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   widget.document.subtitle,
                  //   style: Theme.of(context).textTheme.bodySmall,
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  const SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     _buildMetaChip(
                  //       context,
                  //       widget.document.size,
                  //       CupertinoIcons.doc_circle,
                  //     ),
                  //     const SizedBox(width: 8),
                  //     _buildMetaChip(
                  //       context,
                  //       widget.document.pages,
                  //       CupertinoIcons.book,
                  //     ),
                  //     const Spacer(),
                  //     const Icon(
                  //       CupertinoIcons.arrow_right,
                  //       size: 16,
                  //       color: AppTheme.primary,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildMetaChip(BuildContext context, String text, IconData icon) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: AppTheme.background,
  //       borderRadius: BorderRadius.circular(6),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, size: 12, color: AppTheme.muted),
  //         const SizedBox(width: 4),
  //         Text(
  //           text,
  //           style: Theme.of(
  //             context,
  //           ).textTheme.bodySmall?.copyWith(fontSize: 10),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
