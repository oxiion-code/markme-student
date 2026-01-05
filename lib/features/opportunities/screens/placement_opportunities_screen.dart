import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/di/college_hive_service.dart';
import 'package:markme_student/features/opportunities/models/placement_args.dart';
import 'package:markme_student/features/student/models/student.dart';

import '../bloc/opportunities_bloc.dart';
import '../bloc/opportunities_event.dart';
import '../bloc/opportunities_state.dart';
import '../models/placement_session.dart';

class PlacementOpportunitiesScreen extends StatefulWidget {
  final Student student;

  const PlacementOpportunitiesScreen({
    super.key,
    required this.student,
  });

  @override
  State<PlacementOpportunitiesScreen> createState() =>
      _PlacementOpportunitiesScreenState();
}

class _PlacementOpportunitiesScreenState
    extends State<PlacementOpportunitiesScreen> {
  @override
  void initState() {
    super.initState();
    final String collegeId = CollegeHiveService.getCollege()!.id;
    context.read<OpportunitiesBloc>().add(
      LoadPlacementSessionsEvent(
        collegeId: collegeId,
        batchId: widget.student.batchId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placement Opportunities'),
        centerTitle: true,
      ),
      body: BlocBuilder<OpportunitiesBloc, OpportunitiesState>(
        builder: (context, state) {
          if (state is OpportunitiesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is OpportunitiesError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is PlacementsLoadedForStudent) {
            if (state.sessions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 40,
                      color: theme.colorScheme.primary.withOpacity(0.6),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No live placement sessions available',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'New opportunities will appear here once announced.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: state.sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final session = state.sessions[index];
                return _PlacementSessionCard(session: session,student: widget.student,);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PlacementSessionCard extends StatelessWidget {
  final PlacementSession session;
  final Student student;

  const _PlacementSessionCard({required this.session, required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final placementArgs=PlacementArgs(student:student , placementSession:session);
          context.push("/placement-details",extra: placementArgs);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: session.status=="live"
                    ? theme.colorScheme.primary
                    : Colors.grey.shade400,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading circle with company initials
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _companyInitials(session.companyName),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: session name + status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            session.sessionName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(isLive: session.status=="live"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Company + role
                    Text(
                      '${session.companyName} • ${session.role}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Drive type pill + eligibility
                    Row(
                      children: [
                        _DriveTypeChip(label: session.driveType),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Min CGPA: ${session.eligibility.minCgpa}  •  Backlogs: ≤ ${session.eligibility.maxBacklogs}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _companyInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.isNotEmpty
          ? parts.first.substring(0, 1).toUpperCase()
          : '?';
    }
    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final second = parts[1].isNotEmpty ? parts[1][0] : '';
    final initials = (first + second).trim();
    return initials.isEmpty ? '?' : initials.toUpperCase();
  }
}

class _DriveTypeChip extends StatelessWidget {
  final String label;

  const _DriveTypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isLive;

  const _StatusBadge({required this.isLive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isLive ? Colors.green : Colors.grey;
    final bgColor = isLive
        ? Colors.green.withOpacity(0.12)
        : Colors.grey.withOpacity(0.18);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLive ? Icons.circle : Icons.timelapse,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isLive ? 'LIVE' : 'CLOSED',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
