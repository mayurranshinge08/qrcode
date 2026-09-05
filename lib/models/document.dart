abstract class LibraryItem {
  final String title;
  final String subtitle;

  const LibraryItem({
    required this.title,
    required this.subtitle,
  });
}

class PdfDocumentItem extends LibraryItem {
  final String fileName;
  final String size;
  final String pages;
  final String qrData;

  const PdfDocumentItem({
    required super.title,
    required super.subtitle,
    required this.fileName,
    required this.size,
    required this.pages,
    required this.qrData,
  });
}

class FolderItem extends LibraryItem {
  final List<PdfDocumentItem> documents;
  final String? imagePath;

  const FolderItem({
    required super.title,
    required super.subtitle,
    required this.documents,
    this.imagePath,
  });
}
