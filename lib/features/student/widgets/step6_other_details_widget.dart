import 'package:flutter/material.dart';

class Step6OtherDetails extends StatelessWidget {
  final TextEditingController admissionDateController;
  final TextEditingController genderController;
  final TextEditingController regdNoController;
  final TextEditingController rollNoController;

  const Step6OtherDetails({
    super.key,
    required this.admissionDateController,
    required this.genderController,
    required this.regdNoController,
    required this.rollNoController,
  });

  static const List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Other Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 25),

            _inputField(
              context: context,
              label: "Admission Date",
              controller: admissionDateController,
              icon: Icons.calendar_today,
              isDate: true,
            ),

            const SizedBox(height: 18),

            _dropdownField(
              context: context,
              label: "Gender",
              controller: genderController,
              icon: Icons.person_outline,
              options: genderOptions,
            ),

            const SizedBox(height: 18),

            _inputField(
              label: "Registration No",
              controller: regdNoController,
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 18),

            _inputField(
              label: "Roll No",
              controller: rollNoController,
              icon: Icons.confirmation_number_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    BuildContext? context,
    TextInputType keyboardType = TextInputType.text,
    bool isDate = false,
  }) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null; // valid
      },
      controller: controller,
      keyboardType: keyboardType,
      readOnly: isDate,
      onTap: isDate
          ? () async {
        final ctx = context!;
        DateTime? picked = await showDatePicker(
          context: ctx,
          initialDate: DateTime.now(),
          firstDate: DateTime(1980),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          controller.text =
          "${picked.day.toString().padLeft(2, '0')}/"
              "${picked.month.toString().padLeft(2, '0')}/"
              "${picked.year}";
        }
      }
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black54, // 👈 light grey color
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.6),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required List<String> options,
  }) {
    return DropdownButtonFormField<String>(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null; // valid
      },
      initialValue: controller.text.isEmpty ? null : controller.text,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.6),
        ),
      ),
      hint: Text("Select $label"),
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (val) {
        controller.text = val ?? '';
      },
    );
  }
}
