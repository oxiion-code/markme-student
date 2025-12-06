import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../edit_profile/bloc/edit_profile_bloc.dart';
import '../../edit_profile/bloc/edit_profile_event.dart';
import '../../edit_profile/bloc/edit_profile_state.dart';
import '../../student/models/student.dart';
import '../../student/models/student_cubit.dart';

class ChangeSectionScreen extends StatefulWidget {
  const ChangeSectionScreen({super.key});

  @override
  State<ChangeSectionScreen> createState() => _ChangeSectionScreenState();
}

class _ChangeSectionScreenState extends State<ChangeSectionScreen> {
  String? selectedSection;

  @override
  void initState() {
    super.initState();
    final student = context.read<StudentCubit>().state;
    if (student != null) {
      context.read<EditProfileBloc>().add(
        LoadSectionsForStudentEvent(batchId: student.batchId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, Student?>(
      builder: (context, student) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Change Section",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: student == null
              ? const Center(child: Text('No student selected'))
              : BlocListener<EditProfileBloc, EditProfileState>(
            listener: (context, state) {
              if (state is SectionChangedForStudent) {
                context.read<StudentCubit>().updateStudent(student.copyWith(sectionId: state.sectionId));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Section updated to ${state.sectionId.split("_").join(" ").toUpperCase()}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // 👈 go back after success
              } else if (state is EditProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟡 Current section info card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.class_, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Current Section: ${student.sectionId.split("_").join(" ").toUpperCase()}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Select New Section",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  BlocBuilder<EditProfileBloc, EditProfileState>(
                    builder: (context, state) {
                      if (state is EditProfileLoading &&
                          selectedSection == null) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is EditProfileError) {
                        return Text(
                          "Error: ${state.message}",
                          style: const TextStyle(color: Colors.red),
                        );
                      } else if (state is SectionsLoadedForStudent) {
                        final sections = state.sections;
                        if (sections.isEmpty) {
                          return const Text(
                            "No sections available.",
                            style: TextStyle(color: Colors.grey),
                          );
                        }

                        return DropdownButtonFormField<String>(
                          initialValue: selectedSection,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          hint: const Text("Choose a section"),
                          items: sections
                              .map(
                                (section) => DropdownMenuItem(
                              value: section,
                              child: Text(section
                                  .split("_")
                                  .join(" ")
                                  .toUpperCase()),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSection = value;
                            });
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),

                  const SizedBox(height: 30),

                  // 🟠 Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedSection == null
                          ? null
                          : () {
                        // 🔥 Dispatch event to update section
                        context.read<EditProfileBloc>().add(
                          ChangeSectionOfStudentEvent(
                            studentId: student.id,
                            sectionId: selectedSection!,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
