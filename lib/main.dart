import 'package:carwashbooking/Screens/Homescreen.dart';
import 'package:carwashbooking/Screens/SignupScreen.dart';
import 'package:carwashbooking/Screens/SplashScreen.dart';
import 'package:carwashbooking/Screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
        home: const SplashScreen(),
      routes: {
        //'/home': (context) => const HomeScreen(),
        '/Signup': (context) => const CreateAccountScreen(),
        '/Login': (context) => const LoginScreen(),
      },
    //  home: const HomeScreen(),
    );
  }
}
