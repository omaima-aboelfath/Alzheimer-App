import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_app/utils/firebase_utils.dart';
import 'package:graduation_app/model/user_data.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/screens/theming/app_colors.dart';
import 'package:graduation_app/screens/theming/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../utils/dialog_utils.dart';

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
  // TextEditingController roleController = TextEditingController();
  String? dropDownValue;
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AppColors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
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
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
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
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
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
                        // onChanged: dropDownCallback,
                        onChanged: (value) {
                          setState(() {
                            dropDownValue = value; // Update dropDownValue
                          });
                        },
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
                        onPressed: () async {
                          await register();
                          // Add logic for handling form submission and validation here
                        },
                        child: Text('Register',
                            style: Theme.of(context).textTheme.displaySmall),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: Text('Already have account? login',
                            style: Theme.of(context).textTheme.bodySmall)),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  // void dropDownCallback(String? selectedValue) {
  //   if (selectedValue != null) {
  //     roleController.text = selectedValue;
  //     setState(() {
  //       dropDownValue = selectedValue;
  //     });
  //   }
  // }

  Future<void> register() async {
    // loop on every validator in text form field and see if its valid or not
    // if return null => valid = true
    if (formKey.currentState?.validate() == true) {
      // Show loading dialog
      DialogUtils.showLoading(
          context: context,
          loadingLabel: 'Registering...',
          barrierDismissible: false);
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser newUser = MyUser(
          id: credential.user?.uid ?? '',
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          // role: roleController.text,
          role: dropDownValue!,
        );
        print('before database');
        await FirebaseUtils.addUserToFireStore(newUser);
        print('after database');
        // Update user provider
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(newUser);
        // Hide loading dialog before showing success
        Navigator.of(context).pop();
        print("Register Successfully");
        // DialogUtils.showMessage(
        //     context: context,
        //     title: 'Success',
        //     titleColor: AppColors.greenColor,
        //     message: 'Register Successfully',
        //     closeButtonText: 'Ok',
        //     onClose: () {
        //       Navigator.pop(context);
        //       if (newUser.role == 'Patient') {
        //         Navigator.pushReplacementNamed(
        //             context, PatientScreen.routeName);
        //       } else if (newUser.role == 'Caregiver') {
        //         Navigator.pushReplacementNamed(
        //             context, CaregiverScreen.routeName);
        //       }
        //     });
        /////
        // mine laast
        if (newUser.role == 'Patient') {
          DialogUtils.showHomeLocationDialog(
            context: context,
            patientId: newUser.id,
            onComplete: () {
              Navigator.pushReplacementNamed(context, PatientScreen.routeName);
            },
          );
        } else if (newUser.role == 'Caregiver') {
          Navigator.pushReplacementNamed(context, CaregiverScreen.routeName,
              arguments: newUser.id);
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Register successfully'),
        //     backgroundColor: AppColors.greenColor,
        //   ),
        // );

        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        // Hide loading dialog before showing error
        Navigator.of(context).pop();
        if (e.code == 'email-already-in-use') {
          DialogUtils.showMessage(
            context: context,
            title: 'Error',
            titleColor: AppColors.redColor,
            message: 'The account already exists for that email.',
            closeButtonText: 'Ok',
          );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('The account already exists for that email.'),
          //     backgroundColor: AppColors.redColor,
          //   ),
          // );
          print('The account already exists for that email.');
        }
      } catch (e) {
        // Hide loading dialog before showing general error
        Navigator.of(context).pop();
        DialogUtils.showMessage(
          context: context,
          title: 'Error',
          message: e.toString(),
          titleColor: AppColors.redColor,
        );
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
