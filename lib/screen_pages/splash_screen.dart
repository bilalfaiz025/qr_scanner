import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/screen_pages/auth_screens/login_page.dart';
import 'package:qr_app/widgets/bottom_bar/floaterbar_widget.dart';
import 'package:qr_app/widgets/text_widgets/h1_text_widget.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
     final auth=FirebaseAuth.instance;
    final user=auth.currentUser;
    Future.delayed(const Duration(seconds: 2)).then((value) {
        if(user!=null){
      Get.to(()=>const FloaterBar());
    }
    else{
      Get.to(()=>const LoginPage());
    }
    });
    return  Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
            decoration:  const BoxDecoration(
              gradient:  LinearGradient(
                  colors: [
                    Color.fromARGB(255, 68, 29, 177),
                    Color.fromARGB(255, 240, 234, 234),
                  ],
                stops: [0.0, 1.0],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                tileMode: TileMode.repeated
              )
            ),
            child: const Padding(padding: EdgeInsets.only(top:210),
            child: Column(
              children: [
                Icon(Icons.qr_code,color: Colors.white,size: 80,),
                H1TextWidget(message: "QR Scanner",txtcolor: Colors.white,),
                SizedBox(height: 40,),
                CircularProgressIndicator(color: Colors.white,strokeWidth: 2,strokeCap:StrokeCap.butt,),
              ],
            ),
            )
        ),
      ),
    );
  }
}
