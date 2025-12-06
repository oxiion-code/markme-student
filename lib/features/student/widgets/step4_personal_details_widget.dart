import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ For formatting date

class Step4Personal extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController dobController;
  final TextEditingController categoryController;

  const Step4Personal({
    super.key,
    required this.emailController,
    required this.dobController,
    required this.categoryController,
  });

  @override
  State<Step4Personal> createState() => _Step4PersonalState();
}

class _Step4PersonalState extends State<Step4Personal> {
  final List<String> categories = [
    "General",
    "OBC",
    "SC",
    "ST",
    "EWS",
    "Other"
  ];

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ✅ Close keyboard
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Personal Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _textField(
              label: "Email",
              controller: widget.emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            _dateField(
              context: context,
              label: "Date of Birth",
              controller: widget.dobController,
              icon: Icons.cake_outlined,
            ),

            _dropdownField(
              label: "Category",
              icon: Icons.account_tree_outlined,
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),
    );
  }

  /// Normal TextField
  Widget _textField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null; // valid
        },
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black54, // 👈 light grey color
            fontSize: 14,
          ),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  /// Date picker field
  Widget _dateField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null; // valid
        },
        controller: controller,
        readOnly: true, // ✅ Prevent typing
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            controller.text = DateFormat("dd-MM-yyyy").format(pickedDate);
          }
        },
      ),
    );
  }

  /// Dropdown field
  Widget _dropdownField({
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        initialValue: selectedCategory,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: categories
            .map((cat) => DropdownMenuItem(
          value: cat,
          child: Text(cat),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
            widget.categoryController.text = value ?? "";
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null; // valid
        },
      ),
    );
  }
}
