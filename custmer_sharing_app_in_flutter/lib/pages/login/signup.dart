import 'package:custmer_sharing_app_in_flutter/main.dart';
import 'package:custmer_sharing_app_in_flutter/screen/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import your PostScreen widget
class LoginSignUp extends StatefulWidget {
  const LoginSignUp({super.key});

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Sign-in aborted by user.");
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print("Successfully signed in with Google: ${user.email}");

        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'name': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MoreScreen()),
        );
      } else {
        print("User sign-in failed.");
      }
    } catch (e) {
      print("Sign-in error: ${e.toString()}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5F2D9C),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Center(child: Image.asset('images/img.png', height: 100)),
          ),
          Spacer(),
          Center(
            child: Text(
              "Login/Signup",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffFFFFFF),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              await _signInWithGoogle();
            },
            child: Image.asset('images/img_1.png', height: 75),
          ),
        ],
      ),
    );
  }
}
