import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'document_list_screen.dart';
import '../data/documents.dart';
import '../widgets/document_card.dart';
import 'pdf_reader_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 800;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: isDesktop
                  ? _buildDesktopLayout(context)
                  : _buildMobileLayout(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 48),
        _buildHero(context),
        const SizedBox(height: 64),
        _buildFeatured(context),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 64),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _buildHero(context)),
            const SizedBox(width: 64),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: _buildFeatured(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(CupertinoIcons.book, size: 24),
        const SizedBox(width: 12),
        Text(
          'A CALMER WAY TO READ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Every document,\nwithin reach.',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 24),
        Text(
          'Keep your essential PDFs close, readable, and easy to share.\nScan once and pick up exactly where you left off.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DocumentListScreen()),
            );
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('View PDF Documents'),
              SizedBox(width: 12),
              Icon(CupertinoIcons.arrow_right, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatured(BuildContext context) {
    final featuredDoc = documentList.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FEATURED DOCUMENT',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 360,
          child: DocumentCard(
            document: featuredDoc,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PdfReaderScreen(document: featuredDoc),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
