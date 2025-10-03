import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:universal_html/html.dart' as html;

class ImagePickerService {
  Future<void> pickImage(
      Rx<Uint8List?> imageBytes, RxBool flagSelectedError) async {
    try {
      flagSelectedError.value = false;
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        imageBytes.value = file.bytes;
      } else {
        flagSelectedError.value = true;
      }
    } catch (e) {
      flagSelectedError.value = true;
    }
  }
}

class FilePickerService {

static Future<void> pickFile(
    Rx<Uint8List?> fileBytes, RxString fileType, RxString fileName) async {
  // if (kIsWeb) return; // Ensure it does not run on web

  try {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      fileName.value = file.name;
      fileBytes.value = file.bytes;

      // Check MIME type first
      final mimeType = lookupMimeType(file.name, headerBytes: file.bytes);
      final isImage = mimeType?.startsWith('image/') ?? false;

      // Fallback to check file extension
      const imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'};
      final ext = file.extension?.toLowerCase() ?? '';

      fileType.value = isImage || imageExtensions.contains(ext) 
          ? 'image' 
          : ext.isNotEmpty 
              ? ext 
              : 'file';
    }
  } catch (e) {
    // Handle error
    // print('File pick error: $e');
  }
}
  Future<void> openFile(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final bytes = response.data!;
        final filename = _getFilenameFromUrl(url);
        final mimeType = _getMimeType(filename);

        // Create blob and download
        final blob = html.Blob([bytes], mimeType);
        final anchor = html.AnchorElement(
          href: html.Url.createObjectUrlFromBlob(blob),
        )
          ..setAttribute('download', filename)
          ..click();

        html.Url.revokeObjectUrl(anchor.href!);
      } else {
        throw Exception(
            'Failed to download file - Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Download error: $e');
    }
  }

  String _getFilenameFromUrl(String url) {
    final uri = Uri.parse(url);
    String path = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'file';
    path = path.replaceAll(RegExp(r'[^a-zA-Z0-9\.-_]'), '');
    return path.isEmpty ? 'file' : path;
  }

  String _getMimeType(String filename) {
    return lookupMimeType(filename) ?? 'application/octet-stream';
  }
}
