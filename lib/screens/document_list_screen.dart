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

  @override
  Widget build(BuildContext context) {
    final docs = _filteredDocuments;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 32),
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

                              return GridView.builder(
                                padding: const EdgeInsets.only(bottom: 32),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 24,
                                      mainAxisSpacing: 24,
                                      childAspectRatio:
                                          1.2, // Wider card for folders
                                    ),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  final item = docs[index];
                                  if (item is FolderItem) {
                                    return FolderCard(
                                      folder: item,
                                      onTap: () => _openFolder(item),
                                    );
                                  } else if (item is PdfDocumentItem) {
                                    return DocumentCard(
                                      document: item,
                                      onTap: () => _openPdf(item),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
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
    );
  }
}
