import 'package:flutter/material.dart';

class Step6OtherDetails extends StatefulWidget {
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
  State<Step6OtherDetails> createState() => _Step6OtherDetailsState();
}

class _Step6OtherDetailsState extends State<Step6OtherDetails> {
  bool noRegId = false;
  String? tempId;
  String _generateTempId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return "TMP-${timestamp.toString().substring(7)}";
  }

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
              controller: widget.admissionDateController,
              icon: Icons.calendar_today,
              isDate: true,
            ),

            const SizedBox(height: 18),

            _dropdownField(
              context: context,
              label: "Gender",
              controller: widget.genderController,
              icon: Icons.person_outline,
              options: Step6OtherDetails.genderOptions,
            ),

            const SizedBox(height: 18),

            _inputIdField(
              noRegId: noRegId,
              label: "Registration No",
              controller: widget.regdNoController,
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 18),

            _inputIdField(
              noRegId: noRegId,
              label: "Roll No",
              controller: widget.rollNoController,
              icon: Icons.confirmation_number_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: noRegId,
              onChanged: (value) {
                setState(() {
                  noRegId = value ?? false;
                  if (!noRegId) {
                    tempId = null;
                    widget.regdNoController.clear();
                    widget.rollNoController.clear();
                  }
                });
              },
              title: const Text(
                "I don’t have a Registration ID / Roll ID",
                style: TextStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (tempId == null && noRegId==true)...[
                  Expanded(
                  child: ElevatedButton(
                    onPressed: tempId == null
                        ? () {
                            setState(() {
                              tempId = _generateTempId();
                              widget.regdNoController.text = tempId!;
                              widget.rollNoController.text = tempId!;
                            });
                          }
                        : null,
                    child: const Text("Generate Temporary ID"),
                  ),
                )],
                if (tempId != null&& noRegId==true) ...[
                  const SizedBox(width: 12),
                  Text(
                    "Your Temporary Id: ${tempId!}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
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

  Widget _inputIdField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    BuildContext? context,
    TextInputType keyboardType = TextInputType.text,
    bool isDate = false,
    required bool noRegId,
  }) {
    return TextFormField(
      enabled: !noRegId,
      validator: (value) {
        if (!noRegId && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        return null;// valid
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
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
