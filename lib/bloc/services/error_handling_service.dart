import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorHandlingService {
  static GlobalKey<NavigatorState>? navigatorKey;

  static void showError(String message) {
    final context = navigatorKey!.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        barrierDismissible: true, // Allow closing by tapping outside
        barrierColor: Colors.black54, // Semi-transparent barrier
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 32,
          ),
          title: const Text(
            'Error',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
