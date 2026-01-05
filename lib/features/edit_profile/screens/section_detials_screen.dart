import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/section.dart';
import '../bloc/edit_profile_bloc.dart';
import '../bloc/edit_profile_event.dart';
import '../bloc/edit_profile_state.dart';

class SectionDetailsScreen extends StatefulWidget {
  final String collegeId;
  final String sectionId;

  const SectionDetailsScreen({
    super.key,
    required this.collegeId,
    required this.sectionId,
  });

  @override
  State<SectionDetailsScreen> createState() => _SectionDetailsScreenState();
}

class _SectionDetailsScreenState extends State<SectionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EditProfileBloc>().add(
      GetSectionDetailsEvent(
        collegeId: widget.collegeId,
        sectionId: widget.sectionId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Section Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
          if (state is EditProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EditProfileError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is LoadedSectionDetails) {
            return _buildSectionDetails(state.section);
          }

          return const SizedBox();
        },
      ),
    );
  }

  /// ---------------- UI ----------------
  Widget _buildSectionDetails(Section section) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard(
            icon: Icons.class_,
            title: "Section Information",
            children: [
              _row("Section Name", section.sectionName),
              _row("Branch", section.branchId.toUpperCase()),
            ],
          ),
          const SizedBox(height: 16),

          _infoCard(
            icon: Icons.school,
            title: "Academic Details",
            children: [
              _row(
                "Current Semester",
                "Semester ${section.currentSemesterNumber}",
              ),
              _row("Semester ID", section.currentSemesterId.split("_").join("-").toUpperCase()),
            ],
          ),
          const SizedBox(height: 16),

          _infoCard(
            icon: Icons.event_seat,
            title: "Seat Information",
            children: [
              _row("Total Seats", section.totalSeatsAllocated.toString()),
              _row("Available Seats", section.availableSeats.toString()),
            ],
          ),
          const SizedBox(height: 16),

          _infoCard(
            icon: Icons.meeting_room,
            title: "Room & Faculty",
            children: [
              _row("Default Room", section.defaultRoom!),
              if(section.hodName!=null)
              _row("HOD", section.hodName!),
              if(section.proctorName!=null)
              _row("Proctor", section.proctorName!),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- HELPERS ----------------
  Widget _infoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
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
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
