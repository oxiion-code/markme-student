import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "1. Purpose of the App",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "This app is designed to help students and teachers manage and record attendance digitally.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),

            Text(
              "2. Data Collection",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "The app collects personal information such as name, phone number, and attendance records. "
                  "This information is used solely for attendance tracking and academic purposes.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),

            Text(
              "3. User Responsibilities",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "Students are responsible for ensuring they mark attendance only when present in class. "
                  "Any misuse may lead to disciplinary actions as per institutional policies.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),

            Text(
              "4. Privacy & Security",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "We take privacy seriously and ensure that personal data is not shared with third parties "
                  "without user consent, except when required by law.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),

            Text(
              "5. Changes to Terms",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "These terms may be updated from time to time. Users will be notified of any major changes.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),

            Text(
              "6. Contact",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "For any queries regarding these terms, please contact your institution’s administration.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 30),

            Center(
              child: Text(
                "© 2025 Student Attendance App -MarkMe",
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
