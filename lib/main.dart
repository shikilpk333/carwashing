import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

// ✅ Define custom MaterialColor
const MaterialColor aquaSwatch = MaterialColor(
  0xFF00C8FF,
  <int, Color>{
    50: Color(0xFFE0F7FA),
    100: Color(0xFFB2EBF2),
    200: Color(0xFF80DEEA),
    300: Color(0xFF4DD0E1),
    400: Color(0xFF26C6DA),
    500: Color(0xFF00C8FF), // main color
    600: Color(0xFF00B8E6),
    700: Color(0xFF00A0CC),
    800: Color(0xFF0088B3),
    900: Color(0xFF006080),
  },
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaClean',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: aquaSwatch),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
