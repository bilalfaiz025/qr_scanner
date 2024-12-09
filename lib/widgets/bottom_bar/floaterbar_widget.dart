import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:qr_app/screen_pages/user_screens/qr_generator.dart';
import 'package:qr_app/screen_pages/user_screens/qr_scanner.dart';
import 'package:qr_app/screen_pages/user_screens/user_profile.dart';

class FloaterBar extends StatefulWidget {
  const FloaterBar({super.key});

  @override
  State<FloaterBar> createState() => _FloaterBar();
}

class _FloaterBar extends State<FloaterBar> {
  int _selectedIndex = 0;
  static List<Widget> screens = <Widget>[
    const MyHomePage(),
    const QRScanner(),
    const ProfileScreen(),
  ];
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: screens[_selectedIndex],
      bottomNavigationBar: FloatingNavbar(
        borderRadius: 20,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(0),
        currentIndex: _selectedIndex,
        itemBorderRadius: 20,
        selectedBackgroundColor: const Color.fromARGB(255, 223, 252, 249),
        onTap: (int val) {
          setState(() {
            _selectedIndex = val;
          });
        },
        items: [
          FloatingNavbarItem(icon: Icons.qr_code, title: "QR Generator"),
          FloatingNavbarItem(icon: Ionicons.md_qr_scanner, title: "QR Scanner"),
          FloatingNavbarItem(icon: Icons.person_2, title: "Profile"),
        ],
      ),
    );
  }
}
