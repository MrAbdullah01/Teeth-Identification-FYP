import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teeth_identification_final_year_project/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen(),));
    },);
  }
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage("images/teeth_splash.webp",),
              ),
            ),
            SizedBox(height: 30,),
            Text("Teeth Identification App",style: TextStyle(
              color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18
            ),)
          ],
        ),
      ),
    );
  }
}
