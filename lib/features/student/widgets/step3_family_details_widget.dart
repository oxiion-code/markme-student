import 'package:flutter/material.dart';

class Step3FamilyDetails extends StatelessWidget {
  final TextEditingController fatherNameController;
  final TextEditingController motherNameController;
  final TextEditingController fatherMobileController;
  final TextEditingController motherMobileController;

  const Step3FamilyDetails({
    super.key,
    required this.fatherNameController,
    required this.motherNameController,
    required this.fatherMobileController,
    required this.motherMobileController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Family Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Father Name
              _customTextField(
                label: "Father's Name",
                controller: fatherNameController,
                icon: Icons.man,
              ),

              // Mother Name
              _customTextField(
                label: "Mother's Name",
                controller: motherNameController,
                icon: Icons.woman,
              ),

              // Father Mobile
              _customTextField(
                label: "Father's Mobile",
                controller: fatherMobileController,
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),

              // Mother Mobile
              _customTextField(
                label: "Mother's Mobile",
                controller: motherMobileController,
                icon: Icons.phone_iphone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 100,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        validator:(value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null; // valid
        } ,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black54, // 👈 light grey color
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.8),
          ),
        ),
      ),
    );
  }
}
