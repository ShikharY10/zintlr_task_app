import 'dart:async';
import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/foundation.dart';

class CloudImage with ChangeNotifier{
  String _secureUrl = "";
  String _publicId = "";
  bool _isError = false;
  bool _isUploadingCompleted = false;
  String _uploadData = "";
  final StreamController<String> _uploadProgressStream = StreamController<String>();

  bool get isUploadingCompleted => _isUploadingCompleted;
  String get secureUrl => _secureUrl;
  String get publicId => _publicId;
  bool get isError => _isError;
  String get getUploadData => _uploadData;

  StreamSubscription<String> listenUploadProgress(void Function(dynamic event) onData) {
    return _uploadProgressStream.stream.listen((event) {
      onData(event);
    });
  }

  String _getImageName(String path) {
    List<String> splited = path.split("/");
    String name = splited[splited.length-1].split(".")[0];
    return name;
  }

  erase() {
    _secureUrl = "";
    _publicId = "";
    _isError = false;
    _isUploadingCompleted = false;
    _uploadData = "";
  }

  Future<void> upload(File file) async{
    final cloudinary = Cloudinary.signedConfig(
      apiKey: "733265345174467",
      apiSecret: "DgCSvpxgKoJno_JOaDcbhfMwSP4",
      cloudName: "shikhar-lco",
    );
    final response = await cloudinary.upload(
      file: file.path,
      fileBytes: file.readAsBytesSync(),
      resourceType: CloudinaryResourceType.image,
      folder: "zintlr_internship_task_folder",
      fileName: _getImageName(file.path),
      progressCallback: (count, total) {
        _uploadData = "$count/$total";
        notifyListeners();
      }
    );
    if (response.isSuccessful) {
      _isUploadingCompleted = true;
      _secureUrl = response.publicId ?? "";
      _publicId = response.secureUrl ?? "";
      notifyListeners();
    } else {
      print("=======ERROR======");
      _isError = true;
      _isUploadingCompleted = true;
      _secureUrl = "";
      _publicId = "";
      notifyListeners();
    }
 }
}

class FetchImage with ChangeNotifier {
  String? _filePath;
  bool _isFileSelected = false;
  Uint8List _imageBytes = Uint8List.fromList([]);

  String get filePath => _filePath ?? "";
  bool get isFileSelected => _isFileSelected;
  Uint8List get imageBytes => _imageBytes;

  erase() {
    _filePath = "";
    _isFileSelected = false;
    _imageBytes = Uint8List.fromList([]);
  }

  Future<void> pickImage() async {
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
      _isFileSelected = true;
      _filePath = compressed.absolute.path;
      _imageBytes = compressed.readAsBytesSync();
      print("===File path: $_filePath====");
      notifyListeners();
    }
  }
}


