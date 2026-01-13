import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/core/utils/app_utils.dart';

import 'package:markme_student/features/student/models/student.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_event.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_state.dart';

import '../../student/models/student_cubit.dart';

class EditPersonalDetailsScreen extends StatefulWidget {
  final Student student;

  const EditPersonalDetailsScreen({super.key, required this.student});

  @override
  State<EditPersonalDetailsScreen> createState() =>
      _EditPersonalDetailsScreenState();
}

class _EditPersonalDetailsScreenState extends State<EditPersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final String collegeId=CollegeHiveService.getCollege()!.id;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late String _gender;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _emailController = TextEditingController(text: widget.student.email);
    _dobController = TextEditingController(text: widget.student.dob);
    _gender = widget.student.sex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime initialDate;
    try {
      initialDate = widget.student.dob.isNotEmpty
          ? DateFormat("dd-MM-yyyy").parse(widget.student.dob)
          : DateTime(2000);
    } catch (e) {
      initialDate = DateTime(2000);
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _dobController.text = DateFormat("dd-MM-yyyy").format(picked);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveDetails(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final updatedStudent = widget.student.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        dob: _dobController.text.trim(),
        sex: _gender,
      );
      context.read<EditProfileBloc>().add(
        UpdateProfileOfStudentEvent(
          student: updatedStudent,
          profilePhoto: _selectedImage,
          collegeId: collegeId
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Personal Details")),
      body: SafeArea(
        child: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSuccess) {
              Navigator.pop(context, state.student);
              context.read<StudentCubit>().updateStudent(state.student);
              AppUtils.showCustomSnackBar(context, "Profile updated successfully",isError: false);
            } else if (state is EditProfileError) {
              AppUtils.showCustomSnackBar(context, state.message,isError: true);
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
                    // Profile Image
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : NetworkImage(widget.student.profilePhotoUrl)
                        as ImageProvider,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blue,
                            child: const Icon(Icons.edit,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
        
                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                      val == null || val.isEmpty ? "Enter name" : null,
                    ),
                    const SizedBox(height: 16),
        
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                      val == null || val.isEmpty ? "Enter email" : null,
                    ),
                    const SizedBox(height: 16),
        
                    // DOB
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Date of Birth",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Select date of birth"
                          : null,
                    ),
                    const SizedBox(height: 16),
        
                    // Gender
                    DropdownButtonFormField<String>(
                      value: _gender.isNotEmpty ? _gender : null,
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(value: "Female", child: Text("Female")),
                        DropdownMenuItem(value: "Other", child: Text("Other")),
                      ],
                      onChanged: (val) => setState(() => _gender = val ?? ""),
                      validator: (val) =>
                      val == null || val.isEmpty ? "Select gender" : null,
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
                                : () => _saveDetails(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                color: Colors.white)
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
