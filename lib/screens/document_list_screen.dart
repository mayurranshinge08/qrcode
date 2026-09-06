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
            'assets/images/bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Theme.of(context).scaffoldBackgroundColor),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Text(
                  //   '${documentList.length} carefully collected guides',
                  //   style: Theme.of(context).textTheme.titleMedium,
                  // ),
                  // const SizedBox(height: 24),
                  // SearchField(
                  //   onChanged: (val) => setState(() => _searchQuery = val),
                  // ),
                  const SizedBox(
                    height: 150,
                  ), // Added 100 pixels to push folders down
                  Expanded(
                    child: docs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No documents found',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = 2;
                              if (constraints.maxWidth >= 1200) {
                                crossAxisCount = 5;
                              } else if (constraints.maxWidth >= 900) {
                                crossAxisCount = 4;
                              } else if (constraints.maxWidth >= 600) {
                                crossAxisCount = 3;
                              }

                              // Prevent using more columns than we have items,
                              // which creates massive left/right gaps when centered
                              if (crossAxisCount > docs.length &&
                                  docs.isNotEmpty) {
                                crossAxisCount = docs.length;
                              }

                              final spacing = 40.0;
                              // Calculate width ensuring they fit exactly without wrapping early
                              final itemWidth =
                                  (constraints.maxWidth -
                                      (crossAxisCount - 1) * spacing -
                                      1) /
                                  crossAxisCount;

                              return SingleChildScrollView(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Center(
                                  child: Wrap(
                                    spacing: spacing,
                                    runSpacing: spacing,
                                    alignment: WrapAlignment.center,
                                    children: docs.map((item) {
                                      Widget card = const SizedBox.shrink();
                                      if (item is FolderItem) {
                                        card = FolderCard(
                                          folder: item,
                                          onTap: () => _openFolder(item),
                                        );
                                      } else if (item is PdfDocumentItem) {
                                        card = DocumentCard(
                                          document: item,
                                          onTap: () => _openPdf(item),
                                        );
                                      }
                                      return SizedBox(
                                        width: itemWidth,
                                        height:
                                            itemWidth /
                                            1.2, // Maintain aspect ratio
                                        child: card,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
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
