import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/student/bloc/student_state.dart';
import 'package:markme_student/features/student/models/student.dart';

import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../models/student_cubit.dart';
import '../widgets/step1_profile_widget.dart';
import '../widgets/step2_basics_info_widget.dart';
import '../widgets/step3_family_details_widget.dart';
import '../widgets/step4_personal_details_widget.dart';
import '../widgets/step5_widget_address.dart';
import '../widgets/step6_other_details_widget.dart';

class StudentFormStepper extends StatefulWidget {
  final String phoneNumber;
  const StudentFormStepper({super.key, required this.phoneNumber});

  @override
  State<StudentFormStepper> createState() => _StudentFormStepperState();
}

class _StudentFormStepperState extends State<StudentFormStepper> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController regdNoController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController fatherMobileController = TextEditingController();
  final TextEditingController motherMobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController admissionDateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController distController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController groupController = TextEditingController();

  File? profileImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();
    // Validate the current step before moving forward
    if (_formKey.currentState!.validate()) {
      if (_currentStep == 0 && profileImage == null) {
        AppUtils.showCustomSnackBar(context, "Select profile photo");
        return; // stop navigation
      }
      if (_currentStep < 5) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitForm();
      }
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: FirebaseAuth
            .instance
            .currentUser!
            .uid,
        phoneNumber: widget.phoneNumber,
        profilePhotoUrl:
            "",
        rollNo: rollNoController.text.trim(),
        regdNo: regdNoController.text.trim(),
        name: nameController.text.trim(),
        branchId: branchController.text.trim(),
        sectionId: sectionController.text.trim(),
        group: groupController.text.trim(),
        fatherName: fatherNameController.text.trim(),
        motherName: motherNameController.text.trim(),
        studentMobileNo: widget.phoneNumber,
        fatherMobileNo: "+91${fatherMobileController.text.trim()}",
        motherMobileNo: "+91${motherMobileController.text.trim()}",
        email: emailController.text.trim(),
        dob: dobController.text.trim(),
        category: categoryController.text.trim(),
        admissionDate: admissionDateController.text.trim(),
        sex: genderController.text.trim(),
        deviceToken: "", // Assign device token if available
        batchId: batchController.text.trim(),
        courseId: courseController.text.trim(),
        hostelAddress: HostelAddress(
          hostel: "",
          block: "",
          roomNo: "",
        ), // if needed
        normalAddress: NormalAddress(
          atPo: addressLine1Controller.text.trim(),
          cityVillage: addressLine2Controller.text.trim(),
          dist: distController.text.trim(),
          state: stateController.text.trim(),
          pin: pincodeController.text.trim(),
        ),
      );

      context.read<StudentBloc>().add(
        RegisterStudentEvent(student, profileImage!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      Step1Profile(
        nameController: nameController,
        profileImage: profileImage,
        onPickImage: _pickImage,
      ),
      Step2BasicInfo(
        groupController: groupController,
        branchController: branchController,
        courseController: courseController,
        batchController: batchController,
        sectionController: sectionController,
      ),
      Step3FamilyDetails(
        fatherNameController: fatherNameController,
        motherNameController: motherNameController,
        fatherMobileController: fatherMobileController,
        motherMobileController: motherMobileController,
      ),
      Step4Personal(
        emailController: emailController,
        dobController: dobController,
        categoryController: categoryController,
      ),
      Step5Address(
        addressLine1Controller: addressLine1Controller,
        addressLine2Controller: addressLine2Controller,
        distController: distController,
        stateController: stateController,
        pincodeController: pincodeController,
      ),
      Step6OtherDetails(
        admissionDateController: admissionDateController,
        genderController: genderController,
        regdNoController: regdNoController,
        rollNoController: rollNoController,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Registration"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: BlocListener<StudentBloc, StudentState>(
            listener: (context, state) {
              if (state is StudentRegistrationLoading) {
                AppUtils.showCustomLoading(context);
              }
              if (state is StudentRegistrationError) {
                AppUtils.showCustomSnackBar(
                  context,
                  "Registration failed",
                );
                Navigator.pop(context);

                context.go("/authPhoneNumber");
              } else if (state is StudentRegistered) {
                AppUtils.showCustomSnackBar(
                  context,
                  "Registration Success",
                );
                Navigator.pop(context);
                context.read<StudentCubit>().setStudent(state.student);
                context.go("/home", extra: state.student);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Step ${_currentStep + 1} of ${steps.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / steps.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation(Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: steps,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _prevPage,
                        child: const Text("Back"),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: _currentStep == steps.length - 1
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            )
                          : null,
                      child: Text(
                        _currentStep == steps.length - 1 ? "Submit" : "Next",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
