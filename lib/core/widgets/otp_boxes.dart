import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../theme/app_colors.dart';

class OtpBoxes extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onCompleted;

  const OtpBoxes({super.key, required this.controller, this.onCompleted});

  @override
  State<OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = (screenWidth - 80) / 6; // Responsive field width
    final fieldHeight = fieldWidth * 1.1; // Keep height proportional

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        autoFocus: true,
        cursorColor: Colors.black,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: fieldHeight,
          fieldWidth: fieldWidth,
          activeFillColor: AppColors.scaffoldBg,
          selectedColor: AppColors.primary,
          selectedFillColor: AppColors.secondary,
          inactiveFillColor: AppColors.scaffoldBg,
          inactiveColor: Colors.grey.shade400,
          activeColor: AppColors.primaryDark,
          disabledColor: Colors.grey.shade100,
          borderWidth: 1.2,
        ),
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        onChanged: (_) {},
        onCompleted: widget.onCompleted,
      ),
    );
  }
}
