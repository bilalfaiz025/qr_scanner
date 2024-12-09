import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/screen_pages/auth_screens/sign_up_page.dart';
import 'package:qr_app/widgets/bottom_bar/floaterbar_widget.dart';
import 'package:qr_app/widgets/button_widget/round_button.dart';
import 'package:qr_app/widgets/circular_avatar/circular_avatar.dart';
import 'package:qr_app/widgets/flutter_toaster/user_check_auth.dart';
import 'package:qr_app/widgets/text_field_widget/custom_field_widget.dart';
import 'package:qr_app/widgets/text_field_widget/text_field_widget.dart';
import 'package:qr_app/widgets/text_widgets/h1_text_widget.dart';
import 'package:qr_app/widgets/text_widgets/h3_text_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

FirebaseAuth auth = FirebaseAuth.instance;
bool loading = false;

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final GlobalKey formkey = GlobalKey<FormState>();
    final passwordstate = GlobalKey<FormFieldState>();
    final emailstate = GlobalKey<FormFieldState>();

    void signInWithEmailAndPassword() async {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        // ignore: use_build_context_synchronously
        Get.to(() => const FloaterBar());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          const String n = ('No user found for that email.');
          FirebasesOperations().toastmessage(n);
        } else if (e.code == 'wrong-password') {
          const n = ('Wrong password provided for that user.');
          FirebasesOperations().toastmessage(n);
        } else {
          final String? n = (e.message);
          FirebasesOperations().toastmessage(n!);
        }
      } finally {
        setState(() {
          loading = false;
        });
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Form(
              key: formkey,
              child: Center(
                child: Column(
                  children: [
                    const CircularAvWidget(
                      url: "images/logo.gif",
                    ),
                    const H1TextWidget(
                      message: "Welcome Back!",
                      txtcolor: Colors.black,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const H3TextWidget(
                      message: "Please enter your log in details below",
                      txtcolor: Colors.black,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    EmailTextFieldWidget(
                      labeltxt: "Email",
                      controller: emailController,
                      typeinput: TextInputType.emailAddress,
                      key: emailstate,
                      formkey: emailstate,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    CustomForm(
                      labeltxt: "Password",
                      controller: passwordController,
                      sufixicon: Icons.remove_red_eye,
                      obscure: true,
                      key: passwordstate,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Roundbutton(
                      title: "Login",
                      loading: loading,
                      ontap: () {
                        setState(() {
                          loading = true;
                          // ignore: unrelated_type_equality_checks
                          if (emailController.text != '' &&
                              passwordController.text != '') {
                            signInWithEmailAndPassword();
                          } else {
                            loading = true;
                            FirebasesOperations().toastmessage(
                                "Email or Password can't be empty");
                            loading = false;
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        googleSignUp();
                      },
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 115,
                          ),
                          H3TextWidget(message: "Continue With Google "),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 145, left: 89),
                      child: Row(
                        children: [
                          H3TextWidget(
                            message: "Dont have an account? ",
                            txtcolor: Colors.black.withOpacity(0.7),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const SignUpScreen(),
                                  transition: Transition.circularReveal);
                            },
                            child: H3TextWidget(
                                message: "Sign Up",
                                txtcolor: Colors.black.withOpacity(0.7),
                                txtdecor: TextDecoration.underline,
                                txtweight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  googleSignUp() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      UserCredential user = await auth.signInWithProvider(googleAuthProvider);
      // ignore: unnecessary_null_comparison
      if (user != null) {
        Get.to(const FloaterBar());
        FirebasesOperations().toastmessage('Account Created Successfully');
      } else {
        FirebasesOperations()
            .toastmessage('Error Ocuure during Google Sign Up');
      }
    } catch (e) {
      FirebasesOperations().toastmessage(e.toString());
    }
  }

  bool isValidemail(String email, password) {
    final RegExp urlRegex1 = RegExp(
      "[@._-]",
      caseSensitive: false,
    );
    urlRegex1.hasMatch(email);
    return true;
  }

  bool isValidpass(String pass) {
    final RegExp urlRegex = RegExp(
      ".*[A-Z].*.*[0-9]..*[a-z].*[@._-]",
      caseSensitive: false,
    );
    if (urlRegex.hasMatch(pass)) {
      return true;
    } else {
      return false;
    }
  }
}
