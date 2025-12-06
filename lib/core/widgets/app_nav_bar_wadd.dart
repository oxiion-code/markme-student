import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomAppNavBarNadd extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppNavBarNadd({
    super.key,
    required this.title,
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
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(52);
}
