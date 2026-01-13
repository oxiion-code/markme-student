import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/student/models/student.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_event.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_state.dart';
import '../../../core/di/college_hive_service.dart';
import '../../student/models/student_cubit.dart';

class EditParentDetailsScreen extends StatefulWidget {
  final Student student;

  const EditParentDetailsScreen({super.key, required this.student});

  @override
  State<EditParentDetailsScreen> createState() =>
      _EditParentDetailsScreenState();
}

class _EditParentDetailsScreenState extends State<EditParentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final String collegeId= CollegeHiveService.getCollege()!.id;
  late TextEditingController _fatherNameController;
  late TextEditingController _fatherPhoneController;
  late TextEditingController _motherNameController;
  late TextEditingController _motherPhoneController;

  @override
  void initState() {
    super.initState();
    _fatherNameController =
        TextEditingController(text: widget.student.fatherName);
    _fatherPhoneController =
        TextEditingController(text: widget.student.fatherMobileNo);
    _motherNameController =
        TextEditingController(text: widget.student.motherName);
    _motherPhoneController =
        TextEditingController(text: widget.student.motherMobileNo);
  }

  @override
  void dispose() {
    _fatherNameController.dispose();
    _fatherPhoneController.dispose();
    _motherNameController.dispose();
    _motherPhoneController.dispose();
    super.dispose();
  }

  void _saveParentDetails(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final updatedStudent = widget.student.copyWith(
        fatherName: _fatherNameController.text.trim(),
        fatherMobileNo: _normalizePhone(_fatherPhoneController.text.trim()),
        motherName: _motherNameController.text.trim(),
        motherMobileNo: _normalizePhone(_motherPhoneController.text.trim()),
      );

      context.read<EditProfileBloc>().add(
        UpdateProfileOfStudentEvent(
          student: updatedStudent,
          profilePhoto: null,
          collegeId: collegeId// No photo change here
        ),
      );
    }
  }

  /// Ensure phone has `+` and only digits (fallback to +91 if not given)
  String _normalizePhone(String input) {
    if (input.startsWith("+")) {
      return input; // already with country code
    }
    // Default to +91 if no country code
    return "+91$input";
  }

  String? _validatePhone(String? val, String parent) {
    if (val == null || val.isEmpty) return "Enter $parent's phone";
    // allow + followed by 10-15 digits (international format)
    if (!RegExp(r'^\+\d{10,15}$').hasMatch(val)) {
      return "Enter valid phone with country code (e.g., +919876543210)";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Parent Details")),
      body: SafeArea(
        child: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSuccess) {
              context.read<StudentCubit>().updateStudent(state.student);
              Navigator.pop(context, state.student);
              AppUtils.showCustomSnackBar(
                context,
                "Parent details updated successfully",
                isError: false,
              );
            } else if (state is EditProfileError) {
              AppUtils.showCustomSnackBar(
                context,
                state.message,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is EditProfileLoading;
        
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Father Name
                    TextFormField(
                      controller: _fatherNameController,
                      decoration: const InputDecoration(
                        labelText: "Father's Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                      val == null || val.isEmpty ? "Enter father's name" : null,
                    ),
                    const SizedBox(height: 16),
        
                    // Father Phone
                    TextFormField(
                      controller: _fatherPhoneController,
                      decoration: const InputDecoration(
                        labelText: "Father's Phone Number (with country code)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (val) => _validatePhone(val, "father"),
                    ),
                    const SizedBox(height: 16),
        
                    // Mother Name
                    TextFormField(
                      controller: _motherNameController,
                      decoration: const InputDecoration(
                        labelText: "Mother's Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                      val == null || val.isEmpty ? "Enter mother's name" : null,
                    ),
                    const SizedBox(height: 16),
        
                    // Mother Phone
                    TextFormField(
                      controller: _motherPhoneController,
                      decoration: const InputDecoration(
                        labelText: "Mother's Phone Number (with country code)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (val) => _validatePhone(val, "mother"),
                    ),
                    const SizedBox(height: 30),
        
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => _saveParentDetails(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text("Update"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
