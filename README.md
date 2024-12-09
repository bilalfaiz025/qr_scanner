# QR Scanner App
The QR Scanner App is a Flutter-based application that allows users to easily authenticate, scan QR codes, generate QR codes, and store their scanning history. The app is integrated with Firebase for authentication and data storage, providing a seamless and secure user experience.

# Key Features
# User Authentication with Firebase:

- Users can register and log in using Firebase Authentication.
- Secure login and registration functionality with email and password.
- Firebase integration ensures that user data is securely stored and managed.
# Scan QR Codes:
The app allows users to scan QR codes in real-time using the device's camera.
The scanned QR code data is instantly displayed for easy access.
Generate QR Codes:

# Users can create custom QR codes for any text or URL.
- Simple and intuitive UI to input data, generate, and save QR codes.
- Store and View Scan History:

# The app automatically saves scanned QR codes along with their details (such as time and data) in the history section.
Users can easily view past scans and revisit the QR code data at any time.
Firebase Integration:

#  Firebase Authentication handles secure login and registration.
- Firebase Firestore is used to store scan history and user data, enabling cloud sync for a seamless cross-device experience.
Technologies Used
- Flutter: A framework for building natively compiled applications for mobile from a single codebase.
- Firebase: Used for user authentication (Firebase Authentication) and cloud storage (Firestore).
Dart: Programming language used for building the Flutter app.
QR Code Scanning: Uses the qr_code_scanner package for scanning QR codes.
QR Code Generation: Uses the qr_flutter package for generating QR codes.
