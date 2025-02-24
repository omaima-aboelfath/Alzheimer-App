import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/auth/forgot_password_screen.dart';
import 'package:graduation_app/screens/auth/register_screen.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/screens/theming/app_colors.dart';
import 'package:graduation_app/screens/theming/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/firebase_utils.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController emailController =
      TextEditingController(text: 'omaima22@gmail.com');

  TextEditingController passwordController =
      TextEditingController(text: '123456');

  bool isObscure = true;
  late StreamSubscription<List<ConnectivityResult>>
      subscription; // Corrected type

  @override
  void initState() {
    super.initState();
    checkInitialConnection(); // Check connectivity immediately
    listenToConnectivity();
  }

  // Initial connectivity check
  Future<void> checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      DialogUtils.showNoInternetDialog(context: context);
    }
  }

  // Listen to connectivity changes
  void listenToConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        DialogUtils.showNoInternetDialog(context: context);
      } else {
        return;
        // showInternetRestoredSnackBar();
      }
    });
  }

  // Show dialog when no internet
  // void showNoInternetDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('No Internet Connection'),
  //       content: const Text('Please check your network and try again.'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(ctx).pop(),
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Show snackbar when internet is restored
  void showInternetRestoredSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Internet connection restored.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text('Welcome Back!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 25)),
            ),
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
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            ForgotPasswordScreen.routeName,
                          );
                        },
                        child: Text('Forgot your password?',
                            style: Theme.of(context).textTheme.bodySmall)),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(AppColors.lightBlue)),
                          onPressed: () async {
                            //if caregiver => caregiverScreen
                            //if patient => patient screen
                            await login(userProvider);
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
                          Navigator.pushReplacementNamed(
                              context, RegisterScreen.routeName);
                        },
                        child: Text('Didnt have account? create one here',
                            style: Theme.of(context).textTheme.bodySmall)),
                  ],
                ))
          ],
        ),
      ),
    );
  }
  // my code
  // Future<void> login(UserProvider userProvider) async {
  //   // loop on every validator in text form field and see if its valid or not
  //   // if return null => valid = true
  //   if (formKey.currentState?.validate() == true) {
  //     // Check internet connection before login
  //     var connectivityResult = await Connectivity().checkConnectivity();
  //     if (connectivityResult == ConnectivityResult.none) {
  //       DialogUtils.showMessage(
  //         context: context,
  //         title: 'No Internet Connection',
  //         message: 'Please check your internet connection and try again.',
  //         titleColor: Colors.red,
  //       );
  //       return;
  //     }
  //     //todo: show loading
  //     DialogUtils.showLoading(
  //         context: context,
  //         loadingLabel: 'Logging in...',
  //         barrierDismissible: false);
  //     try {
  //       final credential =
  //           await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text,
  //         password: passwordController.text,
  //       );
  //       // Hide loading dialog before further processing
  //       Navigator.of(context).pop(); // Dismiss loading dialog
  //       var user = await FirebaseUtils.readUserFromFireStore(
  //           credential.user?.uid ?? '');
  //       print('Logged in user: ${credential.user?.email}');
  //       if (user == null) {
  //         // if not exist in firebase
  //         // Show error if user not found in Firestore
  //         DialogUtils.showMessage(
  //           context: context,
  //           title: 'Error',
  //           message: 'User profile not found.',
  //           titleColor: AppColors.redColor,
  //         );
  //         return;
  //       }
  //       // not care about every update, no update in UI, get the info of user one time & if he changes i dont care
  //       // var userProvider = Provider.of<UserProvider>(context, listen: false);
  //       userProvider.updateUser(user);
  //       //todo: hide loading
  //       // DialogUtils.hideLoading(context);
  //       // //show message
  //       // DialogUtils.showMessage(
  //       //     context: context,
  //       //     message: 'Login Successfully',
  //       //     title: 'Success',
  //       //     posActionName: 'Ok',
  //       //     posAction: () {
  //       //       Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  //       //     });
  //       print("Login Successfully");
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   const SnackBar(
  //       //     content: Text('Login successfully'),
  //       //     backgroundColor: AppColors.greenColor,
  //       //   ),
  //       // );
  //       DialogUtils.showMessage(
  //           context: context,
  //           title: 'Success',
  //           titleColor: AppColors.greenColor,
  //           message: 'Login Successfully',
  //           onClose: () {
  //             Navigator.pop(context);
  //             if (userProvider.currentUser?.role == 'Patient') {
  //               Navigator.pushReplacementNamed(
  //                   context, PatientScreen.routeName);
  //             } else if (userProvider.currentUser?.role == 'Caregiver') {
  //               Navigator.pushReplacementNamed(
  //                   context, CaregiverScreen.routeName,
  //                   arguments: userProvider.currentUser!.id);
  //             }
  //           });
  //       // print user id and if not found print null
  //       print(credential.user?.uid ?? "");
  //       // }
  //       // on FirebaseAuthException catch (e) {
  //       //   if (e.code == 'user-not-found') {
  //       //     print('No user found for that email.');
  //       //   } else if (e.code == 'wrong-password') {
  //       //     print('Wrong password provided for that user.');
  //       // }
  //     } on FirebaseAuthException catch (e) {
  //       // Hide loading dialog before showing error
  //       Navigator.of(context).pop();
  //       if (e.code == 'invalid-credential') {
  //         DialogUtils.showMessage(
  //           context: context,
  //           title: 'Error',
  //           message:
  //               // 'The supplied auth credential is incorrect, malformed or has expired',
  //               '${e.message}',
  //           titleColor: AppColors.redColor,
  //         );
  //         // ScaffoldMessenger.of(context).showSnackBar(
  //         //   const SnackBar(
  //         //       content: Text(
  //         //           'The supplied auth credential is incorrect, malformed or has expired.'),
  //         //       backgroundColor: AppColors.redColor),
  //         // );
  //         print(
  //             'The supplied auth credential is incorrect, malformed or has expired.');
  //       }
  //     } catch (e) {
  //       print(e
  //           .toString()); // print the string of exception that not specified above
  //       print('Login failed: ${e.toString()}');
  //       // Hide loading dialog before showing general error
  //       Navigator.of(context).pop();
  //       DialogUtils.showMessage(
  //         context: context,
  //         title: 'Error',
  //         message: '${e.toString()},',
  //         titleColor: AppColors.redColor,
  //       );
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(
  //       //     content: Text(e.toString()),
  //       //     backgroundColor: AppColors.redColor,
  //       //   ),
  //       // );
  //     }
  //   }
  // }

  Future<void> login(UserProvider userProvider) async {
    // Validate form inputs
    if (formKey.currentState?.validate() == true) {
      try {
        // Check internet connection with timeout
        var connectivityResult = await Connectivity()
            .checkConnectivity()
            .timeout(const Duration(seconds: 3), onTimeout: () {
          throw Exception('Internet check timed out.');
        });

        if (connectivityResult == ConnectivityResult.none) {
          // No internet connection, show error message
          DialogUtils.showMessage(
            context: context,
            title: 'No Internet Connection',
            message: 'Please check your internet connection and try again.',
            titleColor: Colors.red,
          );
          return; // Exit function early
        }

        // Show loading dialog
        DialogUtils.showLoading(
          context: context,
          loadingLabel: 'Logging in...',
          barrierDismissible: false,
        );

        // Attempt login with Firebase
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Fetch user data from Firestore
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');

        if (user == null) {
          // User not found in Firestore
          Navigator.of(context).pop(); // Hide loading
          DialogUtils.showMessage(
            context: context,
            title: 'Error',
            message: 'User profile not found.',
            titleColor: AppColors.redColor,
          );
          return;
        }

        // Update user in provider
        userProvider.updateUser(user);

        // Update Firestore with the new password
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .update({'password': passwordController.text});

        // Hide loading dialog
        Navigator.of(context).pop();

        // Show success message and navigate based on role
        DialogUtils.showMessage(
          context: context,
          title: 'Success',
          titleColor: AppColors.greenColor,
          message: 'Login Successfully',
          onClose: () {
            Navigator.pop(context); // Close dialog
            if (userProvider.currentUser?.role == 'Patient') {
              Navigator.pushReplacementNamed(context, PatientScreen.routeName);
            } else if (userProvider.currentUser?.role == 'Caregiver') {
              Navigator.pushReplacementNamed(
                context,
                CaregiverScreen.routeName,
                arguments: userProvider.currentUser!.id,
              );
            }
          },
        );
        print("Login Successfully: ${credential.user?.uid ?? ''}");
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop(); // Hide loading dialog
        // Handle Firebase-specific login errors
        DialogUtils.showMessage(
          context: context,
          title: 'Error',
          message: e.message ?? 'Login failed. Please try again.',
          titleColor: AppColors.redColor,
        );
      } on Exception catch (e) {
        // General exception or timeout
        Navigator.of(context).pop(); // Hide loading dialog
        DialogUtils.showMessage(
          context: context,
          title: 'Error',
          message: e.toString(),
          titleColor: AppColors.redColor,
        );
        print('Login failed: ${e.toString()}');
      }
    }
  }
}
