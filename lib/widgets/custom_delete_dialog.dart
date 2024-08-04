import 'package:flutter/material.dart';

void showConfirmationDialog(
    BuildContext context, String message, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this $message?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              onDelete(); // Call the provided callback
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
