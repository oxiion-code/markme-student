import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_bloc.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_event.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_state.dart';

import '../widgets/document_upload_card.dart';

class DocumentVerificationScreen extends StatefulWidget {
  final String studentId;
  const DocumentVerificationScreen({super.key, required this.studentId});

  @override
  State<DocumentVerificationScreen> createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  final String collegeId = CollegeHiveService.getCollege()!.id;

  /// 📄 Document configuration
  final Map<String, Map<String, dynamic>> documents = {
    '10th Certificate': {
      'status': 'not_uploaded',
      'fileName': null,
      'filePath': null,
      'isOptional': false,
    },
    '10th Mark Sheet': {
      'status': 'not_uploaded',
      'fileName': null,
      'filePath': null,
      'isOptional': false,
    },
    '12th Certificate': {
      'status': 'not_uploaded',
      'fileName': null,
      'filePath': null,
      'isOptional': false,
    },
    '12th Mark Sheet': {
      'status': 'not_uploaded',
      'fileName': null,
      'filePath': null,
      'isOptional': false,
    },
    'Aadhaar Card': {
      'status': 'not_uploaded',
      'fileName': null,
      'filePath': null,
      'isOptional': false,
    },
    'JEE / OJEE Mark Sheet': {
      'status': 'not_uploaded',
      'fileName': null,
      'filePath': null,
      'isOptional': true,
    },
    'Diploma Certificate': {
      'status': 'not_uploaded',
      'fileName': null,
      'filePath': null,
      'isOptional': true,
    },
    'ITI Certificate': {
      'status': 'not_uploaded',
      'fileName': null,
      'filePath': null,
      'isOptional': true,
    },
    'Conduct Certificate': {
      'status': 'not_uploaded',
      'fileName': null,
      'filePath': null,
      'isOptional': false,
    },
  };

  /// ✅ Submit enabled only if all required docs are uploaded
  bool get isSubmitEnabled {
    return documents.entries
        .where((e) => !(e.value['isOptional'] ?? false))
        .every((e) => e.value['status'] == 'uploaded');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileVerificationBloc, ProfileVerificationState>(
      listener: (context, state) {
        if (state is ProfileVerificationLoading) {
          AppUtils.showCustomLoading(context);
        } else {
          AppUtils.hideCustomLoading(context);
        }

        if (state is DocumentsUploaded) {
          AppUtils.showCustomSnackBar(
            context,
            "Documents uploaded successfully",
          );
          context.pop("uploaded");
        } else if (state is ProfileVerificationError) {
          AppUtils.showCustomSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Document Verification',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 32),
                const Text(
                  'Required Documents',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
          
                /// 📂 Document cards
                ...documents.entries.map(
                      (entry) => DocumentUploadCard(
                    documentName: entry.key,
                    documentData: entry.value,
                    onUpload: (fileName, filePath) {
                      setState(() {
                        documents[entry.key]!['status'] = 'uploaded';
                        documents[entry.key]!['fileName'] = fileName;
                        documents[entry.key]!['filePath'] = filePath;
                      });
                    },
                    onRemove: () {
                      setState(() {
                        documents[entry.key]!['status'] = 'not_uploaded';
                        documents[entry.key]!['fileName'] = null;
                        documents[entry.key]!['filePath'] = null;
                      });
                    },
                    onReplace: (fileName, filePath) {
                      setState(() {
                        documents[entry.key]!['fileName'] = fileName;
                        documents[entry.key]!['filePath'] = filePath;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            top: 12,
          ),
          child: _submitButton(),
        ),

      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_rounded, size: 48, color: Colors.blue.shade600),
          const SizedBox(height: 12),
          const Text(
            'Upload required documents',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your profile verification to get section allotment',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: isSubmitEnabled
                  ? const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              )
                  : null,
              borderRadius: BorderRadius.circular(16),
              color: isSubmitEnabled ? null : Colors.grey[300],
            ),
            child: ElevatedButton(
              onPressed: isSubmitEnabled ? _showConfirmationDialog : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'Submit for Verification',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Confirm Submission',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: documents.entries.map((entry) {
            final uploaded = entry.value['status'] == 'uploaded';
            final mandatory = !(entry.value['isOptional'] ?? false);
            return Row(
              children: [
                Icon(
                  uploaded ? Icons.check_circle : Icons.cancel,
                  color: uploaded
                      ? Colors.green
                      : (mandatory ? Colors.red : Colors.grey),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(entry.key),
              ],
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSubmission(context);
            },
            child: const Text('Confirm & Submit'),
          ),
        ],
      ),
    );
  }

  void _handleSubmission(BuildContext context) {
    final Map<String, File> filesToUpload = {};

    documents.forEach((key, value) {
      if (value['status'] == 'uploaded' && value['filePath'] != null) {
        filesToUpload[key] = File(value['filePath']);
      }
    });

    context.read<ProfileVerificationBloc>().add(
      UploadDocumentsForVerificationEvent(
        studentId: widget.studentId,
        collegeId: collegeId,
        documents: filesToUpload,
      ),
    );
  }
}
