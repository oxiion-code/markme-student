import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../student/models/student.dart';
import '../../student/models/student_cubit.dart';

class EditProfileOptionsScreen extends StatelessWidget {
  const EditProfileOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, Student?>(
      builder: (context, student) {
        if (student == null) {
          // Show loading or fallback if student is not yet loaded
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Edit Profile",
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            iconTheme: const IconThemeData(color: Colors.black87),
            backgroundColor: Colors.blue.shade50,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildOptionCard(
                  context,
                  title: "Change Personal Details",
                  subtitle: "Name, DOB, Email, Gender, Photo",
                  icon: CupertinoIcons.person_alt_circle,
                  color: Colors.blueAccent,
                  onClick: () {
                    context.push('/editPersonalDetail', extra: student);
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionCard(
                  context,
                  title: "Change Parent Details",
                  subtitle: "Phone Number, Name",
                  icon: CupertinoIcons.person_2_alt,
                  color: Colors.orangeAccent,
                  onClick: () {
                    context.push('/editParentDetail', extra: student);
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionCard(
                  context,
                  title: "Change Address",
                  subtitle: "Hostel Address, Permanent Address",
                  icon: MaterialCommunityIcons.home,
                  color: Colors.green,
                  onClick: () {
                    context.push('/editAddressDetail', extra: student);
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionCard(
                  context,
                  title: "Update Roll/Reg. No",
                  subtitle: "Change Roll or Reg. Number",
                  icon: MaterialCommunityIcons.format_list_numbered,
                  color: Colors.pink,
                  onClick: () {
                    context.push('/update-roll-reg-no', extra: student);
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionCard(
                  context,
                  title: "Section Details",
                  subtitle: "Review your section details",
                  icon: MaterialCommunityIcons.details,
                  color: Colors.brown,
                  onClick: () {
                    context.push('/section-details', extra: student.sectionId);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onClick,
      }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        trailing: const Icon(
          CupertinoIcons.chevron_forward,
          size: 20,
          color: Colors.grey,
        ),
        onTap: onClick,
      ),
    );
  }
}
