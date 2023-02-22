import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);
  final file = await File('${(await getTemporaryDirectory()).path}/$path')
      .create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return file;
}
