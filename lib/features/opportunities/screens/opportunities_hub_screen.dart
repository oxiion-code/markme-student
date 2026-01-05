import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/opportunities/bloc/opportunities_bloc.dart';
import 'package:markme_student/features/opportunities/bloc/opportunities_event.dart';
import 'package:markme_student/features/student/models/student.dart';
import 'package:markme_student/features/opportunities/models/student_application.dart';

import '../bloc/opportunities_state.dart';

class OpportunitiesHubScreen extends StatefulWidget {
  final Student student;
  const OpportunitiesHubScreen({super.key, required this.student});

  @override
  State<OpportunitiesHubScreen> createState() => _OpportunitiesHubScreenState();
}

class _OpportunitiesHubScreenState extends State<OpportunitiesHubScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OpportunitiesBloc>().add(
      LoadAppliedFormsEvent(studentId: widget.student.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Opportunities Hub',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explore Section
            Text(
              'Explore your opportunities',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Swipe to explore options',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: opportunities.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final opportunity = opportunities[index];
                  return OpportunityCard(
                    icon: opportunity['icon'] as IconData,
                    title: opportunity['title'] as String,
                    subtitle: opportunity['subtitle'] as String,
                    route: opportunity['route'] as String,
                    student: widget.student,
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Applied Opportunities Section
            Text(
              'Applied opportunities',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),

            // BLoC Builder for Applied Applications
            Expanded(
              child: BlocBuilder<OpportunitiesBloc, OpportunitiesState>(
                builder: (context, state) {
                  if (state is OpportunitiesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is AppliedFormsLoaded) {
                    if (state.applications.isEmpty) {
                      return _buildEmptyApplications();
                    }
                    return ListView.separated(
                      itemCount: state.applications.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final application = state.applications[index];
                        return AppliedOpportunityCard(
                          application: application,
                          student: widget.student,
                        );
                      },
                    );
                  } else if (state is OpportunitiesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<OpportunitiesBloc>().add(
                                LoadAppliedFormsEvent(studentId: widget.student.id),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildEmptyApplications();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyApplications() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No applications yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Apply to opportunities above to track your applications here',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> opportunities = [
  {
    'icon': Icons.work_outline,
    'title': 'Internships',
    'subtitle': 'Active opportunities',
    'route': '/internships',
  },
  {
    'icon': Icons.business_center,
    'title': 'Placements',
    'subtitle': 'Campus hiring drives',
    'route': '/placements',
  },
  {
    'icon': Icons.event,
    'title': 'Special Events',
    'subtitle': 'Workshops & webinars',
    'route': '/events',
  },
];

class OpportunityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Student student;


  const OpportunityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.student,

  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: InkWell(
        onTap: () {
          if (route == "/placements") {
            context.push(route, extra: student).then((r){
             context.read<OpportunitiesBloc>().add(
               LoadAppliedFormsEvent(
                  studentId: student.id,
                ),
              );
            });
          } else {
            AppUtils.showCustomSnackBar(
              context,
              "No $title found",
              isError: true,
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

class AppliedOpportunityCard extends StatelessWidget {
  final StudentApplication application;
  final Student student;

  const AppliedOpportunityCard({
    super.key,
    required this.application,
    required this.student,
  });

  Color _getStatusColor() {
    switch (application.status) {
      case 'selected':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'withdrawn':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon() {
    switch (application.status) {
      case 'selected':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'withdrawn':
        return Icons.undo;
      default:
        return Icons.schedule;
    }
  }

  /// ✅ Withdraw allowed only within 2 hours
  bool _canWithdraw() {
    try {
      final appliedTime = DateTime.parse(application.appliedAt);
      final now = DateTime.now();
      return now.difference(appliedTime).inHours < 2;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status Indicator
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getStatusIcon(),
              color: _getStatusColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Company & Job Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  application.companyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  application.jobTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      application.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Applied ${_formatDate(application.appliedAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey[400]),
            onSelected: (value) {
              if (value == 'withdraw') {
                _showWithdrawConfirmation(context);
              }
            },
            itemBuilder: (context) => [
              if (application.status == 'applied' && _canWithdraw())
                const PopupMenuItem(
                  value: 'withdraw',
                  child: Row(
                    children: [
                      Icon(Icons.undo, size: 20, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Withdraw',
                          style: TextStyle(color: Colors.orange)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day} ${_getMonthShort(date.month)}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthShort(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  void _showWithdrawConfirmation(BuildContext context) {
    final collegeId = CollegeHiveService.getCollege()!.id;
    final parentContext = context;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Application'),
        content: Text(
          'Are you sure you want to withdraw your application for '
              '${application.jobTitle} at ${application.companyName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              parentContext.read<OpportunitiesBloc>().add(
                DeleteApplicationEvent(
                  sessionId: application.sessionId,
                  collegeId: collegeId,
                  studentId: student.id,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }
}
