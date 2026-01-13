import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/class_session.dart';

class LiveClassDetailScreen extends StatelessWidget {
  final ClassSession classSession;
  const LiveClassDetailScreen({super.key, required this.classSession});

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'ended':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return Icons.play_circle_fill;
      case 'scheduled':
        return Icons.schedule;
      case 'ended':
        return Icons.check_circle_outline;
      default:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${classSession.subjectName} - Live Class",style: TextStyle(
          color: Colors.black87
        ),),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blue.shade50,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject Title
                  Text(
                    classSession.subjectName,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Section: ${classSession.sectionName} (Sem ${classSession.semesterNo})",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Divider(thickness: 1.2),

                  // Teacher & Room Row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.person,
                            title: "Teacher",
                            subtitle: classSession.teacherName,
                          ),
                        ),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.meeting_room,
                            title: "Room",
                            subtitle: classSession.roomName,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(thickness: 1.2),

                  // Date & Time Row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.calendar_today,
                            title: "Date",
                            subtitle: _formatDate(classSession.date),
                          ),
                        ),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.access_time,
                            title: "Time",
                            subtitle: "${_formatTime(classSession.startTime)} - ${_formatTime(classSession.endTime)}",
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(thickness: 1.2),

                  // Status with Icon and colored text
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(classSession.status),
                          color: _getStatusColor(classSession.status),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          classSession.status.toUpperCase(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(classSession.status),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Session Type and Group in a single ListTile style box
                  _InfoTile(
                    icon: Icons.category,
                    title: "Session Type",
                    subtitle: "${classSession.sessionType} (${classSession.group})",
                  ),

                  const SizedBox(height: 16),

                  // Attendance Status
                  ListTile(
                    leading: const Icon(Icons.assignment_turned_in),
                    title: const Text("Attendance Status"),
                    subtitle: Text(
                        classSession.attendanceId == null ? "Not Taken" : "Taken",
                        style: TextStyle(
                          color: classSession.attendanceId == null ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
