import 'package:flutter/material.dart';

class Step5Address extends StatelessWidget {
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController distController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;

  const Step5Address({
    super.key,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.distController,
    required this.stateController,
    required this.pincodeController,
  });

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
              "Address Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 25),

            _inputField(
              label: "Village/Po",
              controller: addressLine1Controller,
              icon: Icons.home,
            ),

            const SizedBox(height: 18),

            _inputField(
              label: "City",
              controller: addressLine2Controller,
              icon: Icons.home_work,
            ),

            const SizedBox(height: 18),

            _inputField(
              label: "District",
              controller: distController,
              icon: Icons.location_city,
            ),

            const SizedBox(height: 18),

            _inputField(
              label: "State",
              controller: stateController,
              icon: Icons.map,
            ),

            const SizedBox(height: 18),

            _inputField(
              label: "Pincode",
              controller: pincodeController,
              icon: Icons.pin_drop,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
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
}
