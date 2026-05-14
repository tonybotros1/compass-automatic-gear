import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts.dart';
import '../../Models/attachments/attachments_model.dart';
import '../../web_functions.dart';
import '../main screen widgets/auto_size_box.dart';

Future<dynamic> documentsScreen({required List<Attachments> documents}) {
  final imageDocuments = documents.where(_isImageAttachment).toList();
  final otherDocuments = documents
      .where((document) => !_isImageAttachment(document))
      .toList();

  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 500,
        width: 700,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: mainColor,
              ),
              child: Row(
                spacing: 10,
                children: [
                  Text('Documents', style: fontStyleForScreenNameUsedInButtons),
                  const Spacer(),
                  closeIcon(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: documents.isEmpty
                    ? const Center(child: Text('No files found'))
                    : ListView(
                        children: [
                          _AttachmentSection(
                            title: 'Images',
                            emptyText: 'No images',
                            documents: imageDocuments,
                            showImagePreview: true,
                          ),
                          const SizedBox(height: 18),
                          _AttachmentSection(
                            title: 'Other Files',
                            emptyText: 'No other files',
                            documents: otherDocuments,
                            showImagePreview: false,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _AttachmentSection extends StatelessWidget {
  const _AttachmentSection({
    required this.title,
    required this.emptyText,
    required this.documents,
    required this.showImagePreview,
  });

  final String title;
  final String emptyText;
  final List<Attachments> documents;
  final bool showImagePreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (documents.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.shade50,
            ),
            child: Text(
              emptyText,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          )
        else
          ...documents.map(
            (document) => _AttachmentFileRow(
              document: document,
              showImagePreview: showImagePreview,
            ),
          ),
      ],
    );
  }
}

class _AttachmentFileRow extends StatelessWidget {
  const _AttachmentFileRow({
    required this.document,
    required this.showImagePreview,
  });

  final Attachments document;
  final bool showImagePreview;

  @override
  Widget build(BuildContext context) {
    final fileName = document.fileName ?? '';
    final fileExtension = returnFileExtension(fileName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _openAttachmentFile(document),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            spacing: 10,
            children: [
              _AttachmentPreview(
                document: document,
                showImagePreview: showImagePreview,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    AutoSizedText(
                      text: fileName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      constraints: const BoxConstraints(),
                    ),
                    AutoSizedText(
                      text: fileExtension,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Open file',
                onPressed: () => _openAttachmentFile(document),
                icon: const Icon(Icons.open_in_new, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({
    required this.document,
    required this.showImagePreview,
  });

  final Attachments document;
  final bool showImagePreview;

  @override
  Widget build(BuildContext context) {
    final fileName = document.fileName ?? '';
    final url = document.attachUrl ?? '';

    if (!showImagePreview || url.trim().isEmpty) {
      return _fileLogoPreview(fileName: fileName);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.network(
        url,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _fileLogoPreview(fileName: fileName),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}

Widget _fileLogoPreview({required String fileName}) {
  return SizedBox(
    width: 56,
    height: 56,
    child: Center(child: returnFileLogo(width: 32, fileName: fileName)),
  );
}

bool _isImageAttachment(Attachments document) {
  final resourceType = (document.resourceType ?? '').toLowerCase();
  if (resourceType == 'image') return true;

  final format = (document.format ?? '').toLowerCase();
  final extension = _fileExtension(document.fileName ?? '');
  const imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
    'heic',
    'heif',
    'tif',
    'tiff',
    'svg',
  };

  return imageExtensions.contains(format) ||
      imageExtensions.contains(extension);
}

String _fileExtension(String fileName) {
  final dotIndex = fileName.lastIndexOf('.');
  if (dotIndex == -1 || dotIndex == fileName.length - 1) return '';
  return fileName.substring(dotIndex + 1).split('?').first.toLowerCase();
}

void _openAttachmentFile(Attachments document) {
  final url = document.attachUrl ?? '';
  final fileName = (document.fileName ?? '').trim().isEmpty
      ? 'attachment'
      : document.fileName!.trim();

  if (url.trim().isEmpty) {
    showSnackBar('Alert', 'File link is missing');
    return;
  }

  FilePickerService().openFile(url, fileName);
}
