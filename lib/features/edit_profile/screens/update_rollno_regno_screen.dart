import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/student/models/student_cubit.dart';

import '../../student/models/student.dart';
import '../bloc/edit_profile_bloc.dart';
import '../bloc/edit_profile_event.dart';
import '../bloc/edit_profile_state.dart';

class UpdateStudentRegOrRollNoScreen extends StatefulWidget {
  final Student student;
  final String collegeId;

  const UpdateStudentRegOrRollNoScreen({
    super.key,
    required this.student,
    required this.collegeId,
  });

  @override
  State<UpdateStudentRegOrRollNoScreen> createState() =>
      _UpdateStudentRegOrRollNoScreenState();
}

class _UpdateStudentRegOrRollNoScreenState
    extends State<UpdateStudentRegOrRollNoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _rollController;
  late TextEditingController _regdController;

  @override
  void initState() {
    super.initState();
    _rollController = TextEditingController(text: widget.student.rollNo);
    _regdController = TextEditingController(text: widget.student.regdNo);
  }

  @override
  void dispose() {
    _rollController.dispose();
    _regdController.dispose();
    super.dispose();
  }

  Future<void> _onUpdatePressed() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final newRoll = _rollController.text.trim();
    final newRegd = _regdController.text.trim();

    /// 1️⃣ Warning dialog
    final warningConfirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('⚠️ Important Warning'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This is a ONE-TIME UPDATE!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 12),
            Text('• Roll & Registration Number can be updated only ONCE'),
            Text('• Admin permission required after this'),
            Text('• Used for exams, placements & academics'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );

    if (warningConfirmed != true) return;

    /// 2️⃣ Final confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Final Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student: ${widget.student.name}'),
            const SizedBox(height: 12),
            _buildFieldComparison('Roll No', newRoll),
            const SizedBox(height: 8),
            _buildFieldComparison('Regd No', newRegd),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Update Now'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    HapticFeedback.heavyImpact();

    /// 3️⃣ Dispatch BLoC event
    context.read<EditProfileBloc>().add(
      UpdateStudentRegOrRollEvent(
        collegeId: widget.collegeId,
        studentId: widget.student.id,
        rollNo: newRoll,
        regNo: newRegd,
      ),
    );
  }

  Widget _buildFieldComparison(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.green.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          Navigator.of(context, rootNavigator: true).pop();
        }

        if (state is UpdatedStudentRegOrRoll) {
          final newRoll = _rollController.text.trim();
          final newRegd = _regdController.text.trim();
          context.read<StudentCubit>().updateStudent(widget.student.copyWith(rollNo: newRoll, regdNo: newRegd));
          AppUtils.showCustomSnackBar(context,"Data updated successfully");
          Navigator.pop(context);
        }
        if (state is EditProfileError) {
          AppUtils.showCustomSnackBar(context,state.message,isError: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Update Student Details')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _rollController,
                    decoration: const InputDecoration(
                      labelText: 'Roll Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.trim().length < 2 ? 'Invalid roll no' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _regdController,
                    decoration: const InputDecoration(
                      labelText: 'Registration Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v == null || v.trim().length < 4 ? 'Invalid regd no' : null,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _onUpdatePressed,
                      icon: const Icon(Icons.save),
                      label: const Text('Update'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
