import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/auth/register_screen.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:graduation_app/utils/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../firebase_utils.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController emailController =
      TextEditingController(text: 'omaima2@gmail.com');

  TextEditingController passwordController =
      TextEditingController(text: '123456');

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AppColors.white)),
        centerTitle: true,
      ),
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
                    keyboardType: TextInputType.number,
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
                        onPressed: () {
                          //if caregiver => caregiverScreen
                          //if patient => patient screen
                          login();
                          if (userProvider.currentUser!.role == 'Patient') {
                            Navigator.pushNamed(
                                context, PatientScreen.routeName);
                          } else if (userProvider.currentUser!.role == 'Caregiver') {
                            Navigator.pushNamed(
                                context, CaregiverScreen.routeName);
                          }
                        },
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

  void login() async {
    // loop on every validator in text form field and see if its valid or not
    // if return null => valid = true
    if (formKey.currentState?.validate() == true) {
      //todo: show loading
      // DialogUtils.showLoading(
      //     context: context,
      //     loadingLabel: 'Loading....',
      //     barrierDismissible: false);
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          // if not exist in firebase
          return;
        }
        // not care about every update, no update in UI, get the info of user one time & if he changes i dont care
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(user);
        //todo: hide loading
        // DialogUtils.hideLoading(context);
        // //show message
        // DialogUtils.showMessage(
        //     context: context,
        //     message: 'Login Successfully',
        //     title: 'Success',
        //     posActionName: 'Ok',
        //     posAction: () {
        //       Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        //     });
        print("Login Successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successfully'),
            backgroundColor: AppColors.greenColor,
          ),
        );
        // Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        // print user id and if not found print null
        print(credential.user?.uid ?? "");
        // }
        // on FirebaseAuthException catch (e) {
        //   if (e.code == 'user-not-found') {
        //     print('No user found for that email.');
        //   } else if (e.code == 'wrong-password') {
        //     print('Wrong password provided for that user.');
        // }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          //todo: hide loading
          // DialogUtils.hideLoading(context);
          // //show message
          // DialogUtils.showMessage(
          //     context: context,
          //     message:
          //         'The supplied auth credential is incorrect, malformed or has expired.',
          //     title: 'Error',
          //     posActionName: 'Ok');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'The supplied auth credential is incorrect, malformed or has expired.'),
                backgroundColor: AppColors.redColor),
          );
          print(
              'The supplied auth credential is incorrect, malformed or has expired.');
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
        print(e
            .toString()); // print the string of exception that not specified above
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
