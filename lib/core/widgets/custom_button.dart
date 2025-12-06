import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';



class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData? icon;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 8,
          shadowColor: AppColors.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            if(icon!=null)...[
              const SizedBox(width: 8,),
              Icon(icon,size:26,)
            ]
          ],
        ),
      ),
    );
  }
}
