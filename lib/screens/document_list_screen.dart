import 'package:flutter/material.dart';
import '../models/document.dart';
import '../data/documents.dart';
import '../widgets/search_field.dart';
import '../widgets/document_card.dart';
import '../widgets/folder_card.dart';
import 'pdf_reader_screen.dart';
import 'folder_screen.dart';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({super.key});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  String _searchQuery = '';

  List<LibraryItem> get _filteredDocuments {
    if (_searchQuery.isEmpty) return documentList;
    final lowerQuery = _searchQuery.toLowerCase();
    return documentList.where((item) {
      return item.title.toLowerCase().contains(lowerQuery) ||
          item.subtitle.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  void _openPdf(PdfDocumentItem document) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PdfReaderScreen(document: document)),
    );
  }

  void _openFolder(FolderItem folder) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => FolderScreen(folder: folder)));
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final docs = _filteredDocuments;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            // Text(
            //   'YOUR READING SHELF',
            //   style: Theme.of(
            //     context,
            //   ).textTheme.bodySmall?.copyWith(letterSpacing: 1.5),
            // ),
            // const SizedBox(height: 4),
            // const Text('PDF Documents'),
          ],
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16.0),
        //     child: Image.asset('assets/images/SUN Logo.jpg', height: 40),
        //   ),
        // ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/folders_screen.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Theme.of(context).scaffoldBackgroundColor),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top area containing the "LEADING WITH INDIAN EVIDENCES" title
                Expanded(flex: 38, child: Container()),
                // Bottom area containing the 2x2 grid of painted folders
                Expanded(
                  flex: 62,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 60.0, // avoid the bottom navigation bar
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Column(
                      children: [
                        // First Row
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.85,
                                    heightFactor: 0.45,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (docs.isNotEmpty) {
                                          _openFolder(docs[0] as FolderItem);
                                        }
                                      },
                                      child: Container(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.85,
                                    heightFactor: 0.45,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (docs.length > 1) {
                                          _openFolder(docs[1] as FolderItem);
                                        }
                                      },
                                      child: Container(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Second Row
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.85,
                                    heightFactor: 0.45,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (docs.length > 2) {
                                          _openFolder(docs[2] as FolderItem);
                                        }
                                      },
                                      child: Container(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.85,
                                    heightFactor: 0.45,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (docs.length > 3) {
                                          _openFolder(docs[3] as FolderItem);
                                        }
                                      },
                                      child: Container(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              GestureDetector(
                onTap: _goBack,
                child: Image.asset('assets/images/Back.png', height: 40),
              ),
              // HOME
              GestureDetector(
                onTap: _goHome,
                child: Image.asset('assets/images/Home.png', height: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
