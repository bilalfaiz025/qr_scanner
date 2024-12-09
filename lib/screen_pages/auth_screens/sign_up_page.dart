import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_app/screen_pages/auth_screens/login_page.dart';
import 'package:qr_app/widgets/button_widget/round_button.dart';
import 'package:qr_app/widgets/flutter_toaster/user_check_auth.dart';
import 'package:qr_app/widgets/text_field_widget/custom_field_widget.dart';
import 'package:qr_app/widgets/text_field_widget/email_text_field.dart';
import 'package:qr_app/widgets/text_field_widget/text_field_widget.dart';
import 'package:qr_app/widgets/text_widgets/h1_text_widget.dart';
import 'package:qr_app/widgets/text_widgets/h3_text_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool isvalid = false;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        print(imageFile);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> signup() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      final storage = FirebaseStorage.instance;

      final uploadTask =
          storage.ref().child('UserProfile.jpg').putFile(imageFile!);
      final snapshot = await uploadTask.whenComplete(() => null);

      final imageUrl = await snapshot.ref.getDownloadURL();

      // Add user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': emailController.text,
        'Name': nameController.text,
        'Password': passwordController.text,
        'image': imageUrl,
      });
      // Navigate to home screen
      Get.to(() => const LoginPage());
      FirebasesOperations().toastmessage('Account Created Successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        FirebasesOperations()
            .toastmessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        FirebasesOperations()
            .toastmessage('The account already exists for that email');
      }
    } catch (e) {
      FirebasesOperations().toastmessage(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body:
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Take a photo'),
                                  onTap: () {
                                    pickImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('Choose from gallery'),
                                  onTap: () {
                                    pickImage(ImageSource.gallery);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: const Color.fromARGB(225, 226, 236, 185),
                      child: CircleAvatar(
                        radius: 63,
                        backgroundImage:
                            imageFile != null ? FileImage(imageFile!) : null,
                        child: imageFile == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 50,
                              )
                            : null,
                      ),
                    ),
                  ),
                  H1TextWidget(
                    message: "Create Account",
                    txtcolor: Colors.black.withOpacity(0.7),
                  ),
                  const H3TextWidget(message: "Enter Information Below"),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldWidget(
                    labeltxt: "Name",
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EmailTextFieldWidget(
                    labeltxt: "Email",
                    controller: emailController,
                  ),
                  CustomForm(
                    labeltxt: 'Password',
                    controller: passwordController,
                  ),
                  CustomForm(
                    labeltxt: 'Confirm Password',
                    controller: confirmpasswordController,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Roundbutton(
                    title: "Sign Up",
                    loading: loading,
                    ontap: () {
                      setState(() {
                        isvalid = isValidpass(passwordController.text);
                        if (nameController.text == '') {
                          FirebasesOperations()
                              .toastmessage('Please Fill Name Field');
                        } else if (emailController.text == '') {
                          FirebasesOperations()
                              .toastmessage('Please Fill Email Field');
                        } else if (passwordController.text == '') {
                          FirebasesOperations()
                              .toastmessage('Please Fill Password Field');
                        } else if (confirmpasswordController.text == '') {
                          FirebasesOperations().toastmessage(
                              'Please Fill Confirm Password Field');
                        } 
                        else if(isvalid == false){
                          FirebasesOperations()
                              .toastmessage('Password dont meet requirements');
                        }
                        else if (passwordController ==
                            confirmpasswordController) {
                            FirebasesOperations().toastmessage(
                              'Password must match with confirm password');
                        }  
                        else{
                          loading = true;
                            signup();
                        }
                          
                      });
                    },
                  )
                ],
              ),
            ),
          )
    );
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
    if (pass.isEmpty) {
      return false;
    }
    final RegExp urlRegex = RegExp(
      "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@%^&*-]).{8,}",
      caseSensitive: false,
    );
    if (urlRegex.hasMatch(pass)) {
      return true;
    } else {
      return false;
    }
  }
}
