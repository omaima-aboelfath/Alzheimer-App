import 'package:flutter/material.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:graduation_app/utils/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  Key formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? dropDownValue;

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
                    keyboardType: TextInputType.name,
                    labelText: 'Enter your Username',
                    controller: usernameController,
                  ),
                  CustomTextfield(
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Enter your Email',
                    controller: emailController,
                  ),
                  CustomTextfield(
                    labelText: 'Enter your Password',
                    controller: passwordController,
                  ),
                  CustomTextfield(
                    labelText: 'Confirm your Password',
                    controller: confirmPasswordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: DropdownButtonFormField(
                      dropdownColor: AppColors.scaffoldColor,
                      hint: Text('Choose Your Role',
                          style: Theme.of(context).textTheme.bodySmall),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                                color: AppColors.mediumBlue, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                                color: AppColors.mediumBlue, width: 1.5)),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 35,
                        color: AppColors.mediumBlue,
                      ),
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            'Patient',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          value: 'Patient',
                        ),
                        DropdownMenuItem(
                          child: Text('Caregiver',
                              style: Theme.of(context).textTheme.bodySmall),
                          value: 'Caregiver',
                        )
                      ],
                      onChanged: dropDownCallback,
                      value: dropDownValue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.lightBlue),
                      ),
                      onPressed: () {
                        if (dropDownValue == 'Patient') {
                          Navigator.pushNamed(context, PatientScreen.routeName);
                        } else if (dropDownValue == 'Caregiver') {
                          Navigator.pushNamed(
                              context, CaregiverScreen.routeName);
                        }
                        // Add logic for handling form submission and validation here
                      },
                      child: Text('Register',
                          style: Theme.of(context).textTheme.displaySmall),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      },
                      child: Text('Already have account? login',
                          style: Theme.of(context).textTheme.bodySmall)),
                ],
              ))
        ],
      ),
    );
  }

  void dropDownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        dropDownValue = selectedValue;
      });
    }
  }
}
