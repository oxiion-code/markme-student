import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:markme_student/core/models/academic_batch.dart';
import 'package:markme_student/core/models/branch.dart';
import 'package:markme_student/core/models/course.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/student/bloc/student_bloc.dart';
import 'package:markme_student/features/student/bloc/student_event.dart';
import 'package:markme_student/features/student/bloc/student_state.dart';

class Step2BasicInfo extends StatefulWidget {
  final TextEditingController branchController;
  final TextEditingController courseController;
  final TextEditingController batchController;
  final TextEditingController sectionController;
  final TextEditingController groupController;

  const Step2BasicInfo({
    super.key,
    required this.branchController,
    required this.courseController,
    required this.batchController,
    required this.sectionController,
    required this.groupController,
  });

  @override
  State<Step2BasicInfo> createState() => _Step2BasicInfoState();
}

class _Step2BasicInfoState extends State<Step2BasicInfo> {
  List<Branch> branches = [];
  List<Course> courses = [];
  List<AcademicBatch> batches = [];
  List<String> sections = [];
  final groups = ["GROUP 1", "GROUP 2"];
  int count=0;

  @override
  void initState() {
    super.initState();
    if(count==0){
      context.read<StudentBloc>().add(GetAllCoursesEvent());
      count+=1;
    }
    // Load courses initially
  }

  @override
  Widget build(BuildContext context) {
    double cardMaxWidth = MediaQuery.of(context).size.width > 520
        ? 500
        : double.infinity;

    return BlocListener<StudentBloc, StudentState>(
      listener: (context, state) {
        if (state is StudentLoading) {
          AppUtils.showCustomFindLoading(context);
        }
        if (state is CoursesLoaded) {
          Navigator.pop(context); // hide loader
          setState(() {
            courses = state.courses;
          });
        }
        if (state is BranchesLoaded) {
          Navigator.pop(context);
          setState(() {
            branches = state.branches;
          });
        }
        if (state is BatchesLoaded) {
          Navigator.pop(context);
          setState(() {
            batches = state.batches;
          });
        }
        if (state is SectionsLoaded) {
          Navigator.pop(context);
          setState(() {
            sections = state.sections;
          });
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: cardMaxWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if(courses.isNotEmpty)
              _dropdownCard<Course>(
                context,
                "Course",
                widget.courseController,
                courses,
                    (c) => c.courseName, // ✅ Display course name
                MaterialCommunityIcons.school,
                onChanged: (course) {
                  widget.courseController.text = course.courseId;
                  // Reset child dropdowns
                  widget.branchController.clear();
                  widget.batchController.clear();
                  widget.sectionController.clear();
                  setState(() {
                    branches = [];
                    batches = [];
                    sections = [];
                  });
                  // Fetch branches
                  context.read<StudentBloc>().add(GetBranchesByCourseIdEvent(course.courseId));
                },
              ),
              if(branches.isNotEmpty)
              _dropdownCard<Branch>(
                context,
                "Branch",
                widget.branchController,
                branches,
                    (b) => b.branchName,
                MaterialCommunityIcons.source_branch,
                onChanged: (branch) {
                  widget.branchController.text = branch.branchId;
                  widget.batchController.clear();
                  widget.sectionController.clear();
                  setState(() {
                    batches = [];
                    sections = [];
                  });
                  context.read<StudentBloc>().add(GetBatchesByBranchIdEvent(branch.branchId));
                },
              ),
              if(batches.isNotEmpty)
              _dropdownCard<AcademicBatch>(
                context,
                "Batch",
                widget.batchController,
                batches,
                    (s) => "${s.startYear}-${s.endYear}",
                Feather.calendar,
                onChanged: (batch) {
                  widget.batchController.text =batch.batchId;
                  widget.sectionController.clear();
                  setState(() {
                    sections = [];
                  });
                  context
                      .read<StudentBloc>()
                      .add(GetSectionsByBatchIdEvent( batchId:batch.batchId));
                },
              ),
              if(sections.isNotEmpty)
              _dropdownCard<String>(
                context,
                "Section",
                widget.sectionController,
                sections,
                    (s) => s.split("_")[3],
                Ionicons.people,
                onChanged: (section) {
                  widget.sectionController.text = section;
                },
              ),
              _dropdownCard<String>(
                context,
                "Group",
                widget.groupController,
                groups,
                    (g) => g,
                Ionicons.people_circle_outline,
                onChanged: (group) {
                  widget.groupController.text = group;
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownCard<T>(
      BuildContext context,
      String label,
      TextEditingController controller,
      List<T> options,
      String Function(T) getLabel,
      IconData leadingIcon, {
        required Function(T) onChanged,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        shadowColor: colorScheme.primary.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(leadingIcon, color: colorScheme.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: DropdownButtonFormField<T>(

                    initialValue: controller.text.isEmpty
                      ? null
                      : options.any((e) => getLabel(e) == controller.text)
                      ? options.firstWhere((e) => getLabel(e) == controller.text)
                      : null,
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
                  ),
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.primary),
                  hint: Text("Select $label",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                  items: options
                      .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      getLabel(e),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) onChanged(val);
                  },
                  validator: (value) =>
                  value == null ? "Please select $label" : null,
                  dropdownColor: colorScheme.surface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
