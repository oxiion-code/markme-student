import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/features/class/models/class_session.dart';
import '../../../core/theme/app_colors.dart';

class LiveClassCard extends StatelessWidget {
  final ClassSession classSession;
  const LiveClassCard({super.key, required this.classSession});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.85),
            AppColors.primaryLight.withOpacity(0.92),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withOpacity(0.13),
          width: 1.1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.16),
                width: 0.6,
              ),
            ),
            child: const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.orangeAccent,
              size: 32,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "LIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          fontSize: 12.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        classSession.subjectName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.white.withOpacity(0.84), size: 17),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        classSession.teacherName,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  "Tap ‘See now’ ",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70, fontSize: 13.3, letterSpacing: 0.04),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              minimumSize: const Size(90, 38),
              maximumSize: const Size(110, 38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.arrow_outward, size: 18),
            label: const Text("See now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            onPressed: () {
              context.push("/classDetails",extra: classSession);
            },
          ),
        ],
      ),
    );
  }
}
