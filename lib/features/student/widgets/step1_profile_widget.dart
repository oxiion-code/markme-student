import 'dart:io';
import 'package:flutter/material.dart';

class Step1Profile extends StatelessWidget {
  final TextEditingController nameController;
  final File? profileImage;
  final VoidCallback onPickImage;

  const Step1Profile({
    super.key,
    required this.nameController,
    required this.profileImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatarPicker(),
          const SizedBox(height: 48),
          _buildNameInputField(),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return GestureDetector(
      onTap: onPickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: profileImage != null
                ? ClipOval(
              child: Image.file(
                profileImage!,
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              ),
            )
                : const Icon(
              Icons.person,
              size: 70,
              color: Colors.grey,
            ),
          ),
          if (profileImage == null)
            const Positioned(
              bottom: 10,
              child: Text(
                "Photo",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                profileImage != null ? Icons.edit : Icons.add_a_photo,
                size: 20,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Name is required';
          }
          if (value.trim().length < 3) {
            return 'Name must be at least 3 characters';
          }
          return null; // valid
        },
        controller: nameController,
        decoration: InputDecoration(
          labelText: "Your Name",
          hintText: "Enter your full name",
          labelStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade100,
          prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade500),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

        ),
      ),
    );
  }
}
