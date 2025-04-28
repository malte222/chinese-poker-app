import 'dart:io';

class Logger {
  static Future<void> log(String message) async {
    final directory = Directory(
      '/storage/emulated/0/Download',
    ); // <-- direkt angeben
    final file = File('${directory.path}/ofc_log.txt');

    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString('[$timestamp] $message\n', mode: FileMode.append);
  }
}
