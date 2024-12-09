import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_app/widgets/bottom_bar/floaterbar_widget.dart';
import 'package:qr_app/widgets/button_widget/round_button.dart';
import 'package:qr_app/widgets/flutter_toaster/user_check_auth.dart';

import 'package:qr_app/widgets/text_field_widget/email_text_field.dart';


class UpdateUserInfo extends StatefulWidget {
  const UpdateUserInfo({super.key});

  @override
  State<UpdateUserInfo> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<UpdateUserInfo> {
  bool loading = false;
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        FirebasesOperations().toastmessage('No image selected.');
      }
    });
  }

  Future<void> signup() async {
    try {
      final storage = FirebaseStorage.instance;

      final uploadTask =
          storage.ref().child('UserProfile.jpg').putFile(imageFile!);
      final snapshot = await uploadTask.whenComplete(() => null);

      final imageUrl = await snapshot.ref.getDownloadURL();

      // Add user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'Name': nameController.text,
        'image': imageUrl,
      });
      // Navigate to home screen
      Get.to(() => const FloaterBar());
      FirebasesOperations().toastmessage('Information Updated Successfully');
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
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
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
                  TextFieldWidget(
                    labeltxt: "Name",
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Roundbutton(
                    title: "Update Information",
                    loading: loading,
                    ontap: () {
                      setState(() {
                        if (nameController.text == '') {
                          FirebasesOperations()
                              .toastmessage('Please Fill Name Field');
                        } else {
                          loading = true;
                          signup();
                        }
                      });
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}
