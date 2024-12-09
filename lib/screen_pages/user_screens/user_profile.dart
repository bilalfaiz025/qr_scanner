import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/screen_pages/auth_screens/login_page.dart';
import 'package:qr_app/screen_pages/auth_screens/update_user_info.dart';
import 'package:qr_app/widgets/button_widget/small_round_button.dart';
import 'package:qr_app/widgets/flutter_toaster/user_check_auth.dart';
import 'package:qr_app/widgets/text_widgets/h3_text_widget.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<ProfileScreen> {
  bool isFavorite = false;
  bool isLoading = true;
  final User? user = FirebaseAuth.instance.currentUser;
  String? imageUrl;
  String? uid;
  String? name;
  String? email;
  @override
  void initState() {
    super.initState();
    getData();
  }
  Future<void> getData() async {
    try {
      DocumentSnapshot snapshot = await firestore.collection('users').doc(user!.uid).get();
      imageUrl=snapshot.get('image');
      name=snapshot.get('Name');
      uid=snapshot.get('uid');
      email=snapshot.get('email');
      setState(() {
        isLoading=false;
      });
    } catch (e) {
      FirebasesOperations().toastmessage('Error Getting Data,$e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 33),
            child: Container(
              height: 700,
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height:20 ,),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: imageUrl == null
                        ? const CircleAvatar(
                        backgroundColor: Colors.black,
                              radius: 55,
                              child: Icon(Icons.image_not_supported_outlined,size: 60,),
                          )
                            :  CircleAvatar(
                                backgroundColor: Colors.greenAccent[100],
                                  radius: 60,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(imageUrl!),
                                  radius: 58,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),

                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 20,),
                                const Icon(Icons.person),
                                const SizedBox(width: 10,),
                                const H3TextWidget(message: 'Name',txtweight: FontWeight.bold,),
                                const SizedBox(width: 20,),
                                H3TextWidget(message: name??'Please Wait',txtcolor: Colors.red,),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 20,right: 10),
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 20,),
                                const Icon(Icons.phone),
                                const SizedBox(width: 10,),
                                const Text('UserID',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10,),
                                Text(uid??'Please Wait',style:const TextStyle(color: Colors.red,fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 20,right: 10),
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 20,),
                                const Icon(Icons.email_outlined),
                                const SizedBox(width: 10,),
                                const Text('Email',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                const SizedBox(width: 20,),
                                Text(email??'Please Wait',style: const TextStyle(color: Colors.red)),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50,),
                 SRoundbutton(title: 'Update Info',ontap: (){
                  Get.to(()=>const UpdateUserInfo());

                  },),
                  const SizedBox(height: 90,),
                  IconButton(onPressed: (){
                    final auth=FirebaseAuth.instance;
                    auth.signOut();
                    FirebasesOperations().toastmessage('User Signed Out');
                    Get.to(()=>const LoginPage());
                  }, icon: const Icon(Icons.logout)),
                  const Text('Sign Out')
                ],
              ),
            ),
          ),
        )
    );
  }
}
