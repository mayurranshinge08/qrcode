# PDF Reading Shelf App

A premium Flutter application for browsing and reading PDF documents, complete with QR code support.

## Getting Started

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Add PDF files:**
   Place your PDF files in the `assets/pdfs/` directory (create the directory if it doesn't exist). 
   For the default data, the app expects the following files:
   - `assets/pdfs/flutter_interview_questions.pdf`
   - `assets/pdfs/dart_star_patterns.pdf`
   - `assets/pdfs/internship_assignment_flutter.pdf`

   *Note: If you run the app without these PDFs in place, opening them will show a generic error.*

3. **Run the app:**
   ```bash
   flutter run
   ```

## How to Customize Data

To change the documents listed in the app, edit `lib/data/documents.dart`.

```dart
PdfDocumentItem(
  title: "Your Custom Title",
  subtitle: "Your Custom Subtitle",
  fileName: "your_file_name.pdf", // Must match the file name in assets/pdfs/
  size: "1.2 MB", // Can be anything you want to display
  pages: "12 pages", // Can be anything you want to display
  qrData: "https://example.com/your-url", // The string/URL the QR code will represent
)
```

## How to Build for Android

To create a release APK:
```bash
flutter build apk --release
```
The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`.

To create an Android App Bundle (recommended for Play Store):
```bash
flutter build appbundle --release
```
