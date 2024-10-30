import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:todo/ui/AuthProvider.dart';
import 'package:todo/ui/home/home_screen.dart';
import 'package:todo/ui/sign_in/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "Splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider = Provider.of<AuthUserProvider>(context);
    Future.delayed(Duration(milliseconds: 2500),() async{
    User? curanteUser = FirebaseAuth.instance.currentUser;
    if(curanteUser == null){
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }else{
      await authUserProvider.retrieveUserData();
      if(mounted){
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    }
    });
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/splash.png",
        ),
      ).animate().fade(
        duration: Duration(milliseconds: 2500),
        begin: 0,
        end: 1
      ),
    );
  }
}
