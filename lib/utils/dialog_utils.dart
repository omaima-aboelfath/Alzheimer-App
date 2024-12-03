import 'package:flutter/material.dart';
import 'package:graduation_app/utils/app_colors.dart';

class DialogUtils {
  static void showMessage({
    required BuildContext context,
    required String title,
    required String message,
    Color? titleColor,
    Color? messageColor,
    String closeButtonText = 'Ok',
    void Function()? onClose,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: titleColor ?? AppColors.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: messageColor ?? AppColors.darkBlue, // Default color
              ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed:
                onClose ?? () => Navigator.pop(context), // Default action
            child: Text(
              closeButtonText,
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
