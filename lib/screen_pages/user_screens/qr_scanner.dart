import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';
class QRScanner extends StatefulWidget {
   const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}
 final GlobalKey qrkey=GlobalKey( debugLabel: "qr");
    QRViewController? controllers;
     String codded="";
     bool? dataValid;

class _QRScannerState extends State<QRScanner> {
  @override
  Widget build(BuildContext context) {
     
    return   Scaffold(
      body: Column(
        children: [
          Expanded(
            child: QRView(key: qrkey, onQRViewCreated: onQRViewCreated,overlay: QrScannerOverlayShape(),) ,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50,right: 50),
            child: Text(codded)),
          
          dataValid==false
          ? const Center(child: Text('Invalid Link'),):
          IconButton(onPressed: (){
             setState(() {
              launchUrlString(codded);
             });
          }, icon: const Icon(CupertinoIcons.search))
        ],
      )
    );
  }
  void onQRViewCreated(QRViewController controller){
    controller.scannedDataStream.listen((scandara){
      setState(() {
        codded=scandara.code!;
        dataValid=isValidURL(codded);
      });
    });
    

  }

   bool isValidURL(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }else{
       final RegExp urlRegex = RegExp(
      r"^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$",
      caseSensitive: false,
    );
     urlRegex.hasMatch(value);
     return true;
    }
   
  }

}