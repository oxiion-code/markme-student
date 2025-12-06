import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomAppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onTap;

  const CustomAppNavBar({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF0D47A1), // Dark Blue
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFF1976D2), // Medium Blue
              foregroundColor: Colors.white,
              elevation: 3,
            ),
            onPressed: onTap,
            child: const Icon(Icons.add, size: 20),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}
