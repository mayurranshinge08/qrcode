class PdfDocumentItem {
  final String title;
  final String subtitle;
  final String fileName;
  final String size;
  final String pages;
  final String qrData;

  const PdfDocumentItem({
    required this.title,
    required this.subtitle,
    required this.fileName,
    required this.size,
    required this.pages,
    required this.qrData,
  });
}
