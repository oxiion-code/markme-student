import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/opportunities/models/placement_form.dart';
import 'package:markme_student/features/opportunities/models/placement_session.dart';
import 'package:markme_student/features/student/models/student.dart';

import '../../profile_verification/models/qualification.dart';
import '../bloc/opportunities_bloc.dart';
import '../bloc/opportunities_event.dart';
import '../bloc/opportunities_state.dart';

class RegistrationForStudentScreen extends StatefulWidget {
  final Student student;
  final PlacementSession placementSession;

  const RegistrationForStudentScreen({
    super.key,
    required this.student,
    required this.placementSession,
  });

  @override
  State<RegistrationForStudentScreen> createState() =>
      _RegistrationForStudentScreenState();
}

class _RegistrationForStudentScreenState
    extends State<RegistrationForStudentScreen> {
  bool agreed = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runPreChecks());
  }

  void _runPreChecks() {
    if (widget.student.sectionId.isEmpty) {
      _showAlert('Section Not Allotted', 'Your section is not allotted yet. Please contact admin.');
      return;
    }

    if ((widget.student.regdNo ?? '').startsWith('TMP-') ||
        (widget.student.rollNo ?? '').startsWith('TMP-')) {
      _showAlert('Temporary ID Found', 'Please update your Registration / Roll Number in profile.');
      return;
    }

    if (widget.student.isProfileVerified != 'verified') {
      _showAlert('Profile Not Verified', 'Your profile is not verified yet.');
      return;
    }

    final collegeId = CollegeHiveService.getCollege()?.id ?? '';
    if (collegeId.isEmpty) {
      _showAlert('College Not Found', 'Please select your college first.');
      return;
    }

    context.read<OpportunitiesBloc>().add(
      LoadQualificationDetailsEvent(
        collegeId: collegeId,
        studentId: widget.student.id,
      ),
    );
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Qualification? _find(List<Qualification> list, String type) {
    try {
      return list.firstWhere((q) => q.qualificationType.toLowerCase() == type.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  void _submitApplication(QualificationsLoaded state) {
    if (!agreed) {
      AppUtils.showCustomSnackBar(context, 'Please agree to terms & conditions');
      return;
    }

    final qualifications = state.qualifications;
    final tenth = _find(qualifications, '10th');
    final twelfth = _find(qualifications, '12th');
    final hasMissingDocs = qualifications.any((q) => q.documentUrl == null);

    if (hasMissingDocs || tenth == null || twelfth == null) {
      AppUtils.showCustomSnackBar(
        context,
        'Please upload 10th and 12th certificates before submitting',
        isError: true,
      );
      return;
    }

    setState(() => isSubmitting = true);

    final college = CollegeHiveService.getCollege();
    if (college == null) {
      setState(() => isSubmitting = false);
      AppUtils.showCustomSnackBar(context, 'College data not found', isError: true);
      return;
    }

    final form = PlacementForm(
      applicationId: '${widget.student.id}_${widget.placementSession.sessionId}',
      sessionId: widget.placementSession.sessionId,
      companyId: widget.placementSession.companyId,
      companyName: widget.placementSession.companyName,
      jobTitle: widget.placementSession.role,
      studentId: widget.student.id,
      studentName: widget.student.name,
      registrationNo: widget.student.regdNo,
      courseId: widget.student.courseId,
      batchId: widget.student.batchId,
      tenthCollegeName: tenth.institutionName,
      tenthCertificateUrl: tenth.documentUrl,
      tenthCgpaOrPercentage: tenth.percentage?.toString(),
      twelfthCollegeName: twelfth.institutionName,
      twelfthCertificateUrl: twelfth.documentUrl,
      twelfthCgpaOrPercentage: twelfth.percentage?.toString(),
      undertakingDescription: 'Student has accepted all placement rules.',
      undertakingDate: DateTime.now().toIso8601String(),
      isSelected: false,
      createdAt: DateTime.now().toIso8601String(),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ConfirmationDialog(
        placementSession: widget.placementSession,
        student: widget.student,
        onConfirm: () {
          Navigator.of(context).pop();
          context.read<OpportunitiesBloc>().add(
            SubmitApplicationEvent(
              sessionId: widget.placementSession.sessionId,
              studentId: widget.student.id,
              collegeId: college.id,
              form: form,
            ),
          );
        },
        onCancel: () {
          Navigator.of(context).pop();
          setState(() => isSubmitting = false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final collegeName = CollegeHiveService.getCollege()?.collegeName ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Placement Registration', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<OpportunitiesBloc, OpportunitiesState>(
        builder: (context, state) {
          // Loading state
          if (state is OpportunitiesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (state is OpportunitiesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          // SUCCESS STATE - Navigate back immediately
          if (state is SubmittedApplication) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppUtils.showCustomSnackBar(context, "Submitted application successfully");
              context.pop();
            // Navigate back
            });
            return const Center(
              child: Text("Submitted application successfully"),
            ); // Show nothing while navigating
          }

          // Qualifications loaded state
          if (state is QualificationsLoaded) {
            final tenth = _find(state.qualifications, '10th');
            final twelfth = _find(state.qualifications, '12th');
            final hasMissingDocs = state.qualifications.any((q) => q.documentUrl == null);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PlacementSessionCard(placementSession: widget.placementSession),
                  const SizedBox(height: 24),

                  if (collegeName.isNotEmpty) ...[
                    _DeclarationIntro(student: widget.student, collegeName: collegeName),
                    const SizedBox(height: 24),
                  ],

                  const _RulesDeclaration(),
                  const SizedBox(height: 24),

                  const _AcademicSectionHeader(),
                  const SizedBox(height: 16),
                  ...state.qualifications.map((q) => _QualificationCard(qualification: q)),
                  const SizedBox(height: 24),

                  if (hasMissingDocs || tenth == null || twelfth == null) ...[
                    Card(
                      color: Colors.orange[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange[700]),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Please upload 10th and 12th certificates before submitting',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  _AgreementCheckbox(
                    value: agreed,
                    onChanged: (v) => setState(() => agreed = v ?? false),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (isSubmitting || !agreed || hasMissingDocs ||
                          tenth == null || twelfth == null)
                          ? null
                          : () => _submitApplication(state),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Submit Application',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Default state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _PlacementSessionCard extends StatelessWidget {
  final PlacementSession placementSession;
  const _PlacementSessionCard({required this.placementSession});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.indigo[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.work_outline, color: Colors.blue[700], size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placementSession.companyName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        placementSession.role,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  final PlacementSession placementSession;
  final Student student;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ConfirmationDialog({
    required this.placementSession,
    required this.student,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.assignment_turned_in, color: Colors.orange, size: 28),
          SizedBox(width: 12),
          Text('Confirm Application', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('You are applying for:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(placementSession.companyName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Position: ${placementSession.role}', style: TextStyle(color: Colors.grey[700])),
                Text('Student: ${student.name}', style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Once submitted, you cannot modify this application.'),
        ],
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('Cancel')),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
          child: const Text('Confirm & Submit'),
        ),
      ],
    );
  }
}

class _DeclarationIntro extends StatelessWidget {
  final Student student;
  final String collegeName;
  const _DeclarationIntro({required this.student, required this.collegeName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'I, ${student.name}, bearing Registration No. ${student.regdNo}, currently pursuing my studies at $collegeName, hereby declare that my academic credentials mentioned below are true and correct to the best of my knowledge.',
          style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
        ),
      ),
    );
  }
}

class _RulesDeclaration extends StatelessWidget {
  const _RulesDeclaration();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                ),
                const SizedBox(width: 12),
                const Text('Placement Rules & Declaration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const _Bullet('I shall attend all Mock Interviews, GD Sessions, Skill Development Programs and placement activities.'),
            const _Bullet('I shall attend all Pre-Placement talks organized by employers.'),
            const _Bullet('I assure to maintain required attendance; failing which I may be debarred from placement activities.'),
            const _Bullet('I will abide by all rules & regulations of the T&P Cell.'),
            const _Bullet('I will maintain ethical conduct after joining any organization.'),
            const _Bullet('I will follow all instructions given by T&P Cell coordinators.'),
            const _Bullet('If I fail to deliver my commitments, I will not be eligible for placement support.'),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(color: Colors.blue[400], shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }
}

class _AcademicSectionHeader extends StatelessWidget {
  const _AcademicSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.school, color: Colors.green[700], size: 20),
        ),
        const SizedBox(width: 12),
        const Text('Academic Credentials', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _AgreementCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  const _AgreementCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: CheckboxListTile(
          value: value,
          onChanged: onChanged,
          contentPadding: EdgeInsets.zero,
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, height: 1.4),
              children: [
                const TextSpan(
                  text: 'I hereby declare that the above information is true and I agree to all the ',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                TextSpan(
                  text: 'terms & conditions',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }
}

class _QualificationCard extends StatelessWidget {
  final Qualification qualification;
  const _QualificationCard({required this.qualification});

  @override
  Widget build(BuildContext context) {
    final isDocumentUploaded = qualification.documentUrl != null;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.purple[100], borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.verified_user_outlined, color: Colors.purple[700], size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(qualification.qualificationType, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 16),
            if (qualification.institutionName.isNotEmpty) ...[
              _InfoTile('Institution', qualification.institutionName),
              _InfoTile('Board/University', qualification.boardOrUniversity),
              _InfoTile('Stream', qualification.streamOrSpecialization ?? 'N/A'),
              _InfoTile('Percentage/CGPA', qualification.percentage?.toStringAsFixed(2) ?? 'N/A', isNumeric: true),
              _InfoTile('Passing Year', qualification.passingOutYear.toString()),
            ],
            _InfoTile('Document Status', isDocumentUploaded ? '✅ Uploaded' : '❌ Not Uploaded',
                valueColor: isDocumentUploaded ? Colors.green : Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _InfoTile(String label, String value, {Color? valueColor, bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.only(top: 2),
            child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700], fontSize: 14)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isNumeric ? FontWeight.w600 : FontWeight.normal,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
