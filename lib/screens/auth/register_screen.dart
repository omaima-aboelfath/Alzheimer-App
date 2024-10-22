import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/firebase_utils.dart';
import 'package:graduation_app/model/user_data.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:graduation_app/utils/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'RegisterScreen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  String? dropDownValue;
  bool isObscure = true;

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
                    labelText: 'Enter your Name',
                    controller: nameController,
                    validator: (text) {
                      // trim => remove space before & after string
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter name'; // invalid
                      }
                      return null; // valid
                    },
                  ),
                  CustomTextfield(
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Enter your Email',
                    controller: emailController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter email'; // invalid
                      }
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailController.text);
                      // if email not valid
                      if (!emailValid) {
                        return 'Please enter valid email';
                      }
                      return null; // valid
                    },
                  ),
                  CustomTextfield(
                    obscureText: isObscure,
                    labelText: 'Enter your Password',
                    controller: passwordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter password'; // invalid
                      }
                      if (text.length < 6) {
                        return 'Password must be at least 6 digits';
                      }
                      return null; // valid
                    },
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (isObscure) {
                            isObscure = false;
                          } else {
                            isObscure = true;
                          }
                          setState(() {});
                        },
                        icon: isObscure
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility)),
                  ),
                  CustomTextfield(
                    obscureText: isObscure,
                    labelText: 'Confirm your Password',
                    controller: confirmPasswordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter the same password'; // invalid
                      }
                      if (text.length < 6) {
                        return 'Password must be at least 6 digits';
                      }
                      if (confirmPasswordController.text !=
                          passwordController.text) {
                        return "Confirm password dosen't match password";
                      }
                      return null; // valid
                    },
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (isObscure) {
                            isObscure = false;
                          } else {
                            isObscure = true;
                          }
                          setState(() {});
                        },
                        icon: isObscure
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Role is required';
                        } else {
                          return null;
                        }
                      },
                      dropdownColor: AppColors.scaffoldColor,
                      hint: Text('Choose Your Role',
                          style: Theme.of(context).textTheme.bodySmall),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.mediumBlue, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.mediumBlue, width: 1.5)),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        size: 35,
                        color: AppColors.mediumBlue,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Patient',
                          child: Text(
                            'Patient',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Caregiver',
                          child: Text('Caregiver',
                              style: Theme.of(context).textTheme.bodySmall),
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
                        register();
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
      roleController.text = selectedValue;
      setState(() {
        dropDownValue = selectedValue;
      });
    }
  }

  void register() async {
    // loop on every validator in text form field and see if its valid or not
    // if return null => valid = true
    if (formKey.currentState?.validate() == true) {
      //todo: show loading
      // DialogUtils.showLoading(
      //     context: context,
      //     loadingLabel: 'Loading...',
      //     barrierDismissible: false);
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            role: roleController.text,
            // patientName: roleController.text == 'Patient'
            //     ? nameController.text
            //     : 'caregiver'
                );
        print('before database');
        await FirebaseUtils.addUserToFireStore(myUser);
        print('after database');
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(myUser);
        //todo: hide loading
        // DialogUtils.hideLoading(context);
        // //show message
        // DialogUtils.showMessage(
        //   context: context,
        //   message: 'Register Successfully',
        //   posAction: () {
        //     Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        //   },
        //   posActionName: 'Ok',
        //   title: 'Success',
        // );
        print("Register Successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Register successfully'),
            backgroundColor: AppColors.greenColor,
          ),
        );
        print(credential.user?.uid ?? "");
        // Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } on FirebaseAuthException catch (e) {
        // if (e.code == 'weak-password') {
        //   print('The password provided is too weak.');
        // } else
        // compare between code of error exception(e) with string that specified by FirebaseAuthException
        if (e.code == 'email-already-in-use') {
          //todo: hide loading
          // DialogUtils.hideLoading(context);
          // //show message
          // DialogUtils.showMessage(
          //     context: context,
          //     message: 'The account already exists for that email.',
          //     title: 'Error',
          //     posActionName: 'Ok');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('The account already exists for that email.'),
              backgroundColor: AppColors.redColor,
            ),
          );
          print('The account already exists for that email.');
        }
      } catch (e) {
        //todo: hide loading
        // DialogUtils.hideLoading(context);
        // //show message
        // DialogUtils.showMessage(
        //     context: context,
        //     message: e.toString(),
        //     title: 'Error',
        //     posActionName: 'Ok');
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.redColor,
          ),
        );
      }
    }
  }
}
