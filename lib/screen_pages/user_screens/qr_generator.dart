import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_app/widgets/button_widget/round_button.dart';
import 'package:qr_app/widgets/button_widget/small_round_button.dart';
import 'package:qr_app/widgets/flutter_toaster/user_check_auth.dart';
import 'package:qr_app/widgets/text_field_widget/valid_link_field_widget.dart';
import 'package:qr_app/widgets/text_widgets/h2_text_widget.dart';
import 'package:qr_app/widgets/text_widgets/h3_text_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_bar_code/code/code.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController qrtxtcontroller = TextEditingController();
  String data = '';
  ScreenshotController screenController = ScreenshotController();
  bool show = false;
  bool showQR = false;
  User? userCredential=FirebaseAuth.instance.currentUser;

  void setValues() {
    setState(() {
      data = qrtxtcontroller.text;
      show = true;
      showQR = true;
    });
  }

  Future<void> imagesave() async {
    try {
      final Uint8List? uint8list = await screenController.capture();
      final imageEncoded = base64Encode(uint8list!);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential!.uid)
          .collection('images')
          .add({'image': imageEncoded});

      if (uint8list.toString().isNotEmpty) {
        final PermissionStatus status = await Permission.storage.request();
        if (status.isGranted) {
          final result =
              await ImageGallerySaver.saveImage(uint8list, quality: 90);
          if (result['isSuccess']) {
            FirebasesOperations().toastmessage("Image Saved Successfully");
          } else {
            FirebasesOperations()
                .toastmessage("Error in Saving Image: ${result['error']}");
          }
        } else {
          FirebasesOperations()
              .toastmessage("Permission Denied for Saving Image");
        }
      } else {
        FirebasesOperations().toastmessage("Error in Capturing Screenshot");
      }
    } catch (e) {
      FirebasesOperations().toastmessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const H2TextWidget(message: "QR Generator"),
              ValidTextFieldWidget(labeltxt: 'Enter Link',controller: qrtxtcontroller,),
              const SizedBox(height: 20),
              Roundbutton(
                title: "Create QR",
                ontap: (){
                  bool result=isValidURL(qrtxtcontroller.text);
                  if(result){
                    setValues();

                  }
                  else{
                    qrtxtcontroller.clear();
                    FirebasesOperations().toastmessage('Invalid Link');
                  }
                },
              ),
              const SizedBox(height: 20),
              if (show)
                Screenshot(
                  controller: screenController,
                  child: Code(
                    data: data,
                    codeType: CodeType.qrCode(),
                    color: Colors.red,
                  ),
                ),
              const SizedBox(height: 20),
              if (show)
                 SRoundbutton(title: 'Save Image',ontap:(){
                    imagesave();
                },),
              const SizedBox(height: 20),
              const H3TextWidget(message: "Recent QRs",txtweight: FontWeight.bold,),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential!.uid)
                      .collection('images')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No images found'));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var imageData =
                            snapshot.data!.docs[index].get('image');
                        Uint8List image = base64Decode(imageData.toString());
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 140, vertical: 20),
                          child: Container(
                            width: 200,
                            height: 120,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool isValidURL(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final RegExp urlRegex = RegExp(
      r"^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$",
      caseSensitive: false,
    );
    return urlRegex.hasMatch(value);
  }
}

