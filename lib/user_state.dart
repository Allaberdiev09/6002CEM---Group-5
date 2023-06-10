import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Receiver/receiver_panel.dart';
import 'LoginAndSignUpPage/login_screen.dart';
import 'Offers/offers_screen.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (userSnapshot.hasData) {
          final user = userSnapshot.data!;
          // Retrieve user data from Firestore to get the role
          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasData) {
                final userData = snapshot.data!.data();
                final role = userData?['role'] as String?;
                if (role == 'receiver') {
                  print('User is receiver');
                  return ReceiverPanel();
                } else {
                  print('User is already logged in');
                  return OfferScreen();
                }
              } else if (snapshot.hasError) {
                return const Scaffold(
                  body: Center(
                    child: Text('An error has occurred! Please try again.'),
                  ),
                );
              } else {
                return const Scaffold(
                  body: Center(
                    child: Text('Something went wrong!'),
                  ),
                );
              }
            },
          );
        } else {
          print('User is not logged in yet');
          return Login();
        }
      },
    );
  }
}
