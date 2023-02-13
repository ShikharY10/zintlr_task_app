import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> searchTags(String username) async {
  String path = "http://127.0.0.1:8000/api/v1/searchtags";
  http.Response response = await http.get(
    Uri.parse(path)
  );
  if (response.statusCode == 200) {
    dynamic result = json.decode(String.fromCharCodes(response.bodyBytes));
    return result;
  }
  return [];
}

Future<String?> readImage() async {
  OpenFileDialogParams params = const OpenFileDialogParams(
    dialogType: OpenFileDialogType.image,
    sourceType: SourceType.photoLibrary,
  );
  final String? filePath = await FlutterFileDialog.pickFile(params: params);
  if (filePath != null) {
    var compressed = await FlutterNativeImage.compressImage(
      filePath,
      quality: 60,
      percentage: 60
    );
    String profilPicPath = compressed.absolute.path;
    return profilPicPath;
    // Uint8List res = compressed.readAsBytesSync();
    // imageExt = profilPicPath.split(".")[profilPicPath.split(".").length-1];
    // b64Image = base64.encode(res);
    // // widget.hiveHandler.set("temp","bimage", bimage);
    // setState(() {
    //   picSelected = true;
    // });
  }
  return null;
}