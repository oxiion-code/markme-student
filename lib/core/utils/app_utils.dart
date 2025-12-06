import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_student/core/widgets/loading.dart';


class AppUtils {
  static Future<String?> getCurrentDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
  }


  static void showCustomLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // important!
      builder: (_) => const Dialog(
        backgroundColor: Colors.transparent,
        child: StudentHandLoading(),
      ),
    );
  }

  static void showCustomFindLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // important!
      builder: (_) => const Dialog(
        backgroundColor: Colors.transparent,
        child: DefaultLoading(),
      ),
    );
  }

  // Hide loader
  static void hideCustomLoading(BuildContext context) {
    try {
      Navigator.of(context, rootNavigator: true).pop(); // only closes dialog
    } catch (_) {
      // dialog was already dismissed
    }
  }



  static void showDialogMessage(
    BuildContext context,
    String message,
    String title,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.close_outlined),
          ),
        ],
      ),
    );
  }

  static void showDeleteConfirmation({
    required BuildContext context,
    required VoidCallback onConfirmDelete,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this teacher?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmDelete(); // 👉 perform actual deletion
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
