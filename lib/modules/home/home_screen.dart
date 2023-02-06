import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/component/helperfunctions.dart';
import '../../shared/network/local/cach_helper.dart';
import '../auth/login_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await firebaseAuth.signOut();
              await CacheHelper.removeData(key: "uid");
              nextScreenRep(context, LoginScreen());
            },
            child: const Text("sign out")),
      ),
    );
  }
}
