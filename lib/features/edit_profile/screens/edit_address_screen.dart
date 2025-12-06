import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/student/models/student.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_event.dart';
import 'package:markme_student/features/edit_profile/bloc/edit_profile_state.dart';
import '../../student/models/student_cubit.dart';

class EditAddressScreen extends StatefulWidget {
  final Student student;

  const EditAddressScreen({super.key, required this.student});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  // Normal address controllers
  late TextEditingController _atPoController;
  late TextEditingController _cityVillageController;
  late TextEditingController _distController;
  late TextEditingController _stateController;
  late TextEditingController _pinController;

  // Hostel address controllers
  late TextEditingController _hostelController;
  late TextEditingController _blockController;
  late TextEditingController _roomNoController;

  @override
  void initState() {
    super.initState();

    final normal = widget.student.normalAddress;
    final hostel = widget.student.hostelAddress;

    _atPoController = TextEditingController(text: normal.atPo);
    _cityVillageController = TextEditingController(text: normal.cityVillage);
    _distController = TextEditingController(text: normal.dist);
    _stateController = TextEditingController(text: normal.state);
    _pinController = TextEditingController(text: normal.pin);

    _hostelController = TextEditingController(text: hostel.hostel);
    _blockController = TextEditingController(text: hostel.block);
    _roomNoController = TextEditingController(text: hostel.roomNo);
  }

  @override
  void dispose() {
    _atPoController.dispose();
    _cityVillageController.dispose();
    _distController.dispose();
    _stateController.dispose();
    _pinController.dispose();

    _hostelController.dispose();
    _blockController.dispose();
    _roomNoController.dispose();
    super.dispose();
  }

  void _saveAddress(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final updatedStudent = widget.student.copyWith(
        normalAddress: widget.student.normalAddress.copyWith(
          atPo: _atPoController.text.trim(),
          cityVillage: _cityVillageController.text.trim(),
          dist: _distController.text.trim(),
          state: _stateController.text.trim(),
          pin: _pinController.text.trim(),
        ),
        hostelAddress: widget.student.hostelAddress.copyWith(
          hostel: _hostelController.text.trim(),
          block: _blockController.text.trim(),
          roomNo: _roomNoController.text.trim(),
        ),
      );

      context.read<EditProfileBloc>().add(
        UpdateProfileOfStudentEvent(
          student: updatedStudent,
          profilePhoto: null, // no photo change
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Address")),
      body: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            context.read<StudentCubit>().updateStudent(state.student);
            Navigator.pop(context, state.student);
            AppUtils.showCustomSnackBar(
              context,
              "Address updated successfully",
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Normal Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _atPoController,
                    decoration: const InputDecoration(
                      labelText: "At/PO",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                    val == null || val.isEmpty ? "Enter At/PO" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _cityVillageController,
                    decoration: const InputDecoration(
                      labelText: "City/Village",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                    val == null || val.isEmpty ? "Enter city/village" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _distController,
                    decoration: const InputDecoration(
                      labelText: "District",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                    val == null || val.isEmpty ? "Enter district" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: "State",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                    val == null || val.isEmpty ? "Enter state" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _pinController,
                    decoration: const InputDecoration(
                      labelText: "PIN Code",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Enter PIN code";
                      if (!RegExp(r'^\d{6}$').hasMatch(val)) {
                        return "Enter valid 6-digit PIN";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "Hostel Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _hostelController,
                    decoration: const InputDecoration(
                      labelText: "Hostel",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _blockController,
                    decoration: const InputDecoration(
                      labelText: "Block",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _roomNoController,
                    decoration: const InputDecoration(
                      labelText: "Room No",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
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
                          onPressed:
                          isLoading ? null : () => _saveAddress(context),
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
    );
  }
}
