import 'package:flutter/material.dart';
import 'package:graduation_app/screens/auth/register_screen.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:graduation_app/utils/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login';
  Key formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextfield(
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Enter your Email',
                    controller: emailController,
                  ),
                  CustomTextfield(
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Enter your Password',
                    controller: passwordController,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text('Forgot your password?',
                          style: Theme.of(context).textTheme.bodySmall)),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.lightBlue)),
                        onPressed: () {},
                        child: Text('Login',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold))),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      child: Text('Didnt have account? create here',
                          style: Theme.of(context).textTheme.bodySmall)),
                ],
              ))
        ],
      ),
    );
  }
}
