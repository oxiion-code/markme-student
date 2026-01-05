import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:markme_student/core/utils/app_utils.dart';

class DocumentUploadCard extends StatelessWidget {
  final String documentName;
  final Map<String, dynamic> documentData;
  final Function(String, String) onUpload;
  final VoidCallback onRemove;
  final Function(String, String) onReplace;

  const DocumentUploadCard({
    super.key,
    required this.documentName,
    required this.documentData,
    required this.onUpload,
    required this.onRemove,
    required this.onReplace,
  });

  bool get isUploaded => documentData['status'] == 'uploaded';
  bool get isOptional => documentData['isOptional'] ?? false;
  bool get isMandatory => !isOptional;

  /// Pick PDF file only
  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // ✅ only PDF
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;

      if (isUploaded) {
        onReplace(file.name, file.path!);
      } else {
        onUpload(file.name, file.path!);
      }

      AppUtils.showCustomSnackBar(
        context,
        '$documentName uploaded successfully',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
        border: Border.all(
          color: isUploaded ? Colors.green.shade400 : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document Title with Required / Optional
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: documentName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87),
                ),
                if (isMandatory)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                if (isOptional)
                  TextSpan(
                    text: ' (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Uploaded File Name
          if (isUploaded && documentData['fileName'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                documentData['fileName'],
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),

          // Upload / Preview Button
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickFile(context),
                  icon: Icon(isUploaded ? Icons.edit : Icons.upload_file),
                  label: Text(isUploaded ? 'Replace PDF' : 'Upload PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUploaded ? Colors.orange : Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (isUploaded)
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
