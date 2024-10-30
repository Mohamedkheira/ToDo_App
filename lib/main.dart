import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:todo/TodoProvider.dart';
import 'package:todo/style/app_style.dart';
import 'package:todo/ui/AuthProvider.dart';
import 'package:todo/ui/home/home_screen.dart';
import 'package:todo/ui/home/widget/editeTaskSheet.dart';
import 'package:todo/ui/register/register_screen.dart';
import 'package:todo/ui/sign_in/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/ui/splash/splash_screen.dart';
import 'firebase_options.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
     ChangeNotifierProvider(create: (context) => AuthUserProvider(),),
     ChangeNotifierProvider(create: (context) => TodoProvider(),),
    ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppStyle.lightMode,
          routes: {
            SplashScreen.routeName:(_) => SplashScreen(),
            RegisterScreen.routeName: (_) => RegisterScreen(),
            LoginScreen.routeName: (_) => LoginScreen(),
            HomeScreen.routeName:(_) => HomeScreen(),
            EditeTaskSheet.routeName:(_)=> EditeTaskSheet(),
          },
          initialRoute: SplashScreen.routeName,
        );
      },
    );
  }
}

