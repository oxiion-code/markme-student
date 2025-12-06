import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ClassCard extends StatelessWidget {
  final String subject;
  final String teacher;
  final String date;
  final bool isPresent;

  const ClassCard({
    super.key,
    required this.subject,
    required this.teacher,
    required this.date,
    required this.isPresent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isPresent ? Colors.green.withValues(alpha: 0.28) : Colors.red.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.book_outlined, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        teacher,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[500], size: 14),
                    const SizedBox(width: 4),
                    Text(
                      date.split("-").reversed.join("/ "),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        letterSpacing: 0.1,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: isPresent
                  ? Colors.green.withValues(alpha: 0.11)
                  : Colors.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isPresent ? Colors.green : Colors.red,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPresent ? Icons.check_circle : Icons.cancel,
                  color: isPresent ? Colors.green : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  isPresent ? "Present" : "Absent",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isPresent ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
