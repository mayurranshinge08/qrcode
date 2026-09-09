import 'package:flutter/material.dart';
import '../models/document.dart';
import '../data/documents.dart';
import '../widgets/document_card.dart';
import 'pdf_reader_screen.dart';

class PosterListScreen extends StatefulWidget {
  const PosterListScreen({super.key});

  @override
  State<PosterListScreen> createState() => _PosterListScreenState();
}

class _PosterListScreenState extends State<PosterListScreen> {
  void _openPdf(PdfDocumentItem document) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PdfReaderScreen(document: document)),
    );
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  List<PdfDocumentItem> get _posterDocuments {
    List<PdfDocumentItem> posters = [];
    for (var item in documentList) {
      if (item is FolderItem) {
        for (var doc in item.documents) {
          if (doc.title.toLowerCase().contains('poster')) {
            posters.add(doc);
          }
        }
      }
    }
    return posters;
  }

  @override
  Widget build(BuildContext context) {
    final docs = _posterDocuments;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            const SizedBox(height: 4),
            Text(
              'Posters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/background_image.jpg',
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
                  const SizedBox(height: 32),
                  Expanded(
                    child: docs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Posters Found',
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
                                      0.75, // Taller card for the thumbnail
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
