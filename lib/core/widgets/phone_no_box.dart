import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

class PhoneNumberBox extends StatelessWidget {
  final TextEditingController controller;
  const PhoneNumberBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.hint.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/icons/flag.png",
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 6),
          const Text(
            "+91",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 32,
            width: 1,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: "Enter phone number",
                counterText: '',
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
