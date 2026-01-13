import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_bloc.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_event.dart';
import 'package:markme_student/features/profile_verification/bloc/profile_verification_state.dart';

import '../models/qualification.dart';

class QualificationDetailsScreen extends StatefulWidget {
  final String studentId;
  const QualificationDetailsScreen({super.key,required this.studentId});

  @override
  State<QualificationDetailsScreen> createState() => _QualificationDetailsScreenState();
}

class _QualificationDetailsScreenState extends State<QualificationDetailsScreen> {
  List<Map<String, dynamic>> qualifications = [
    {
      'type': '10th',
      'institution': '',
      'board': '',
      'stream': '',
      'year': '',
      'percentage': '',
      'notes': '',
      'isValid': false,
    }
  ];

  final List<String> qualificationTypes = [
    '10th',
    '12th',
    'Graduation',
    'Diploma',
    'ITI',
    'Others'
  ];

  final List<String> boards = ['CBSE', 'ICSE', 'State Board', 'University', 'Others'];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileVerificationBloc,ProfileVerificationState>(
      listener: (context,state){
        if(state is ProfileVerificationLoading){
          AppUtils.showCustomLoading(context);
        }else{
          AppUtils.hideCustomLoading(context);
        }
        if(state is QualificationDetailsUploaded){
          AppUtils.showCustomSnackBar(context, " Qualification details uploaded");
          context.pop("uploaded");
        }else if(state is ProfileVerificationError){
          AppUtils.showCustomSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Qualification Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.indigo.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade100, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.school_rounded, size: 48, color: Colors.blue.shade600),
                      const SizedBox(height: 12),
                      const Text(
                        'Enter your educational qualifications',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ensure details match your uploaded documents exactly',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
          
                // Qualifications List
                Text(
                  'Qualifications',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                ),
                const SizedBox(height: 20),
          
                ...qualifications.asMap().entries.map((entry) {
                  int index = entry.key;
                  return QualificationCard(
                    key: ValueKey('qual_$index'), // Unique key for proper rebuild
                    qualification: entry.value,
                    qualificationTypes: qualificationTypes,
                    boards: boards,
                    index: index,
                    onUpdated: (updatedQualification) {
                      setState(() {
                        qualifications[index] = updatedQualification;
                      });
                    },
                    onDelete: qualifications.length > 1
                        ? () {
                      setState(() {
                        qualifications.removeAt(index);
                      });
                    }
                        : null,
                  );
                }),
          
                const SizedBox(height: 24),
          
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        qualifications.add({
                          'type': '',
                          'institution': '',
                          'board': '',
                          'stream': '',
                          'year': '',
                          'percentage': '',
                          'notes': '',
                          'isValid': false,
                        });
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                    label: const Text('Add Another Qualification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
         padding:  EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitEnabled() ? _showConfirmationDialog : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitEnabled() ? null : Colors.grey[300],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[500],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Submit Education Details (${_validQualificationsCount()} ${_validQualificationsCount() == 1 ? 'valid' : 'valid'})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _validQualificationsCount() {
    return qualifications.where((q) => q['isValid'] == true).length;
  }

  bool _isSubmitEnabled() {
    return qualifications.every((q) => q['isValid'] == true);
  }

  void _showConfirmationDialog() {
    final parentContext= context;
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.school, color: Colors.green[400], size: 28),
            const SizedBox(width: 12),
            const Text('Verify Details', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please verify that all ${_validQualificationsCount()} educational details are correct and match your uploaded documents exactly.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              '⚠️ Mismatched details may cause verification rejection.\n'
                  '📄 Details must exactly match your certificates.\n'
                  '⏱️ Processing takes 2-3 working days.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Review', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSubmission(parentContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirm & Submit'),
          ),
        ],
      ),
    );
  }

  void _handleSubmission(BuildContext context) {
    final collegeId = CollegeHiveService.getCollege()!.id;

    final List<Qualification> qualificationModels = qualifications
        .where((q) => q['isValid'] == true)
        .map((q) {
      return Qualification(
        qualificationType: q['type'] as String,
        institutionName: q['institution'] as String,
        boardOrUniversity: q['board'] as String,
        streamOrSpecialization:
        (q['stream'] as String).isEmpty ? null : q['stream'],
        percentage: (q['percentage'] as String).isEmpty
            ? null
            : double.tryParse(q['percentage']),
        passingOutYear: int.parse(q['year']),
        notes: (q['notes'] as String).isEmpty ? null : q['notes'],
        isDocumentVerified: false,
      );
    })
        .toList();

    context.read<ProfileVerificationBloc>().add(
      UploadEducationDetailsEvent(
        qualifications: qualificationModels,
        collegeId: collegeId,
        studentId: widget.studentId,
      ),
    );
  }
}

class QualificationCard extends StatefulWidget {
  final Map<String, dynamic> qualification;
  final List<String> qualificationTypes;
  final List<String> boards;
  final int index;
  final Function(Map<String, dynamic>) onUpdated;
  final VoidCallback? onDelete;

  const QualificationCard({
    super.key,
    required this.qualification,
    required this.qualificationTypes,
    required this.boards,
    required this.index,
    required this.onUpdated,
    this.onDelete,
  });

  @override
  State<QualificationCard> createState() => _QualificationCardState();
}

class _QualificationCardState extends State<QualificationCard> {
  late TextEditingController institutionController;
  late TextEditingController boardController;
  late TextEditingController streamController;
  late TextEditingController yearController;
  late TextEditingController percentageController;
  late TextEditingController notesController;
  String? selectedType;
  String? selectedBoard;

  @override
  void initState() {
    super.initState();
    selectedType = widget.qualification['type']?.toString();
    selectedBoard = widget.qualification['board']?.toString();
    institutionController = TextEditingController(text: widget.qualification['institution']?.toString() ?? '');
    boardController = TextEditingController(text: widget.qualification['board']?.toString() ?? '');
    streamController = TextEditingController(text: widget.qualification['stream']?.toString() ?? '');
    yearController = TextEditingController(text: widget.qualification['year']?.toString() ?? '');
    percentageController = TextEditingController(text: widget.qualification['percentage']?.toString() ?? '');
    notesController = TextEditingController(text: widget.qualification['notes']?.toString() ?? '');
  }

  @override
  void dispose() {
    institutionController.dispose();
    boardController.dispose();
    streamController.dispose();
    yearController.dispose();
    percentageController.dispose();
    notesController.dispose();
    super.dispose();
  }

  bool get isValid {
    return selectedType != null &&
        selectedBoard != null &&
        institutionController.text.trim().isNotEmpty &&
        streamController.text.trim().isNotEmpty &&
        _isValidYear(yearController.text.trim()) &&
        _isValidPercentage(percentageController.text.trim());
  }

  bool _isValidYear(String year) {
    if (year.isEmpty) return false;
    final yearNum = int.tryParse(year);
    return yearNum != null && yearNum >= 1900 && yearNum <= DateTime.now().year;
  }

  bool _isValidPercentage(String percentage) {
    if (percentage.isEmpty) return false;
    final percNum = double.tryParse(percentage.replaceAll('%', '').trim());
    return percNum != null && percNum >= 0 && percNum <= 100;
  }

  void _updateParent() {
    widget.onUpdated({
      'type': selectedType ?? '',
      'institution': institutionController.text.trim(),
      'board': selectedBoard ?? '',
      'stream': streamController.text.trim(),
      'year': yearController.text.trim(),
      'percentage': percentageController.text.trim(),
      'notes': notesController.text.trim(),
      'isValid': isValid,
    });
  }

  InputDecoration _inputDecoration(String label, {bool isOptional = false}) {
    return InputDecoration(
      labelText: isOptional ? '$label (Optional)' : label,
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }

  Widget _buildLabel(String label, {bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[800]),
          children: [
            TextSpan(text: label),
            if (!isOptional) ...[
              const TextSpan(text: ' *'),
              TextSpan(
                text: '',
                style: TextStyle(color: Colors.red[400]),
              ),
            ],
            if (isOptional)
              TextSpan(
                text: ' (Optional)',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
        border: Border.all(color: isValid ? Colors.green.shade300 : Colors.grey[300]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isValid ? Colors.green.withValues(alpha:0.1) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isValid ? Icons.check_circle : Icons.pending,
                  color: isValid ? Colors.green : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Qualification ${widget.index + 1}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (widget.onDelete != null)
                IconButton(
                  onPressed: widget.onDelete,
                  icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Qualification Type Dropdown
          _buildLabel('Qualification Type'),
          DropdownButtonFormField<String>(
            value: selectedType != null && widget.qualificationTypes.contains(selectedType!) ? selectedType : null,
            decoration: _inputDecoration('Select qualification type'),
            items: widget.qualificationTypes.map((q) {
              return DropdownMenuItem(value: q, child: Text(q));
            }).toList(),
            onChanged: (v) {
              setState(() {
                selectedType = v;
              });
              _updateParent();
            },
          ),
          const SizedBox(height: 16),

          // Institution
          _buildLabel('Passing Institution'),
          TextFormField(
            controller: institutionController,
            decoration: _inputDecoration('Enter institution name'),
            onChanged: (_) => _updateParent(),
          ),
          const SizedBox(height: 16),

          // Board Dropdown
          _buildLabel('Board / University'),
          DropdownButtonFormField<String>(
            value: selectedBoard != null && widget.boards.contains(selectedBoard!) ? selectedBoard : null,
            decoration: _inputDecoration('Select board/university'),
            items: widget.boards.map((b) {
              return DropdownMenuItem(value: b, child: Text(b));
            }).toList(),
            onChanged: (v) {
              setState(() {
                selectedBoard = v;
              });
              _updateParent();
            },
          ),
          const SizedBox(height: 16),

          // Stream
          _buildLabel('Stream / Specialization'),
          TextFormField(
            controller: streamController,
            decoration: _inputDecoration('Enter stream/specialization'),
            onChanged: (_) => _updateParent(),
          ),
          const SizedBox(height: 16),

          // Year & Percentage Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Year of Passing'),
                    TextFormField(
                      controller: yearController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration('YYYY'),
                      onChanged: (_) => _updateParent(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Percentage / Grade'),
                    TextFormField(
                      controller: percentageController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration('85.5 or First'),
                      onChanged: (_) => _updateParent(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notes
          _buildLabel('Notes', isOptional: true),
          TextFormField(
            controller: notesController,
            maxLines: 3,
            decoration: _inputDecoration('Additional remarks', isOptional: true),
            onChanged: (_) => _updateParent(),
          ),
        ],
      ),
    );
  }
}
