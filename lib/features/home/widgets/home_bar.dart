import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_student/features/student/models/student.dart';

import '../../../core/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget{
  final Student student;
  const HomeAppBar({super.key,required this.student});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha((0.94 * 255).toInt()), // fix for withValues
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                },
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "GITA College, Bhubaneswar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    student.name,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white30,
                child: const Icon(CupertinoIcons.smiley_fill,
                    color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}