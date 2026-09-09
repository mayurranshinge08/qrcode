import 'dart:io';

void main() {
  final file = File('lib/data/documents.dart');
  final content = file.readAsStringSync();
  final regex = RegExp(r'title:\s*"([^"]+)"', multiLine: true);
  var count = 0;
  for (final match in regex.allMatches(content)) {
    final title = match.group(1)!;
    if (title.toLowerCase().contains('poster')) {
      print(title);
      count++;
    }
  }
  print('Total: $count');
}
