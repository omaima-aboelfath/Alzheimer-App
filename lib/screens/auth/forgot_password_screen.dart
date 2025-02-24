import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_app/screens/auth/forgot_password_confirmation_screen.dart';
import 'package:graduation_app/screens/theming/custom_text_field.dart';
import 'package:graduation_app/screens/theming/app_colors.dart';

import '../../utils/dialog_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = 'forgot_password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final email = _emailController.text.trim();
        print('Sending password reset email to $email');

        // Send password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email,
        );
        print('Password reset email sent successfully');

        // Navigate to the confirmation screen
        Navigator.pushReplacementNamed(
          context,
          ForgotPasswordConfirmationScreen.routeName,
        );
      } on FirebaseAuthException catch (e) {
        print('Error: ${e.message}');
        DialogUtils.showMessage(
          context: context,
          title: 'Error',
          message: e.message ?? 'Failed to send password reset email.',
          titleColor: AppColors.redColor,
        );
      } catch (e) {
        print('Unexpected error: $e');
        DialogUtils.showMessage(
          context: context,
          title: 'Error',
          message: 'An unexpected error occurred. Please try again.',
          titleColor: AppColors.redColor,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.white,
              ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 0.18 * height),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Enter your email to reset your password',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 15),
            CustomTextfield(
              keyboardType: TextInputType.emailAddress,
              labelText: 'Enter your Email',
              controller: _emailController,
              validator: (text) {
                if (text == null || text.trim().isEmpty) {
                  return 'Please enter email'; // invalid
                }
                final bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(_emailController.text);
                // if email not valid
                if (!emailValid) {
                  return 'Please enter valid email';
                }
                return null; // valid
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightBlue,
                ),
                child: Text(
                  'Send Reset Link',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}