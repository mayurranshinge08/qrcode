import 'package:flutter/material.dart';
import '../models/document.dart';
import '../data/documents.dart';
import '../widgets/search_field.dart';
import '../widgets/document_card.dart';
import 'pdf_reader_screen.dart';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({super.key});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  String _searchQuery = '';

  List<PdfDocumentItem> get _filteredDocuments {
    if (_searchQuery.isEmpty) return documentList;
    final lowerQuery = _searchQuery.toLowerCase();
    return documentList.where((doc) {
      return doc.title.toLowerCase().contains(lowerQuery) ||
             doc.subtitle.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  void _openPdf(PdfDocumentItem document) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfReaderScreen(document: document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final docs = _filteredDocuments;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'YOUR READING SHELF',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 1.5),
            ),
            const SizedBox(height: 4),
            const Text('PDF Documents'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              '${documentList.length} carefully collected guides',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            SearchField(
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: docs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'No documents found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        if (constraints.maxWidth >= 1000) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth >= 680) {
                          crossAxisCount = 2;
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 32),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: 0.75, // Taller card for the thumbnail
                          ),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            return DocumentCard(
                              document: docs[index],
                              onTap: () => _openPdf(docs[index]),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
