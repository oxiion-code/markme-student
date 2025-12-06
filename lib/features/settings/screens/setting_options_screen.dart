import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/utils/app_utils.dart';
import 'package:markme_student/features/auth/bloc/auth_bloc.dart';
import 'package:markme_student/features/auth/bloc/auth_event.dart';
import 'package:markme_student/features/auth/bloc/auth_state.dart';

class SettingOptionsScreen extends StatelessWidget {
  const SettingOptionsScreen({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, color: Colors.red[700], size: 40),
              const SizedBox(height: 16),
              const Text(
                "Confirm Logout",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 9),
              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      minimumSize: const Size(80, 36),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.go("/authPhoneNumber");
        } else if (state is AuthError) {
          AppUtils.showCustomSnackBar(context, state.error, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: AppBar(
                title: const Text(
                  "Settings",
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                ),
                elevation: 1,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black87),
              ),
              body: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.red[100],
                          child: const Icon(Icons.logout, color: Colors.red, size: 28),
                        ),
                        title: const Text(
                          "Logout",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: const Text(
                          "Sign out from your account",
                          style: TextStyle(fontSize: 14, color: Colors.redAccent),
                        ),
                        onTap: isLoading ? null : () => _confirmLogout(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.green[100],
                          child: const Icon(Icons.people_alt, color: Colors.green, size: 28),
                        ),
                        title: const Text(
                          "Change section",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: const Text(
                          "Change your current section",
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                        onTap: () => context.push("/changeSection"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blue[100],
                          child: const Icon(Icons.developer_mode, color: Colors.blue, size: 28),
                        ),
                        title: const Text(
                          "Developer Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: const Text(
                          "View developer contact information",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        onTap: () => context.push("/developerDetails"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.16),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
