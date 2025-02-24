import 'package:flutter/material.dart';
import 'package:graduation_app/screens/theming/app_colors.dart';

class ForgotPasswordConfirmationScreen extends StatelessWidget {
  static const String routeName = 'forgot_password_confirmation';

  const ForgotPasswordConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check Your Email',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.white,
              ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'We have sent a password reset link to your email.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightBlue,
              ),
              child: Text(
                'Back to Login',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}