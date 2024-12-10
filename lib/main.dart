import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nirut_final_app/admin/adminpage.dart';
import 'package:nirut_final_app/firebase_options.dart';
import 'package:nirut_final_app/pages/01-homepage.dart';
import 'package:nirut_final_app/pages/02-secondpage.dart';
import 'package:nirut_final_app/pages/03_bookingpage.dart';
import 'package:nirut_final_app/pages/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // กำหนดค่า Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    // จัดการข้อผิดพลาดกรณี Firebase ล้มเหลว
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final IS767',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/admin': (context) => const AdminMenuPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const Homepage(),
        '/second': (context) => const Secondpage(),
        '/booking': (context) => const BookingPage(
              movieId: '',
            ),
      },
    );
  }
}

// หน้าจอสำหรับแสดงข้อผิดพลาด
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Failed to initialize Firebase',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
