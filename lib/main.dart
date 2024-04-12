import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mally/presentation/category_screen/photo_three_screen.dart';
import 'package:mally/presentation/home_plus_screen/home_plus_screen.dart';
import 'package:mally/presentation/testPath/testPath.dart';
//import 'package:mally/presentation/app_navigation_screen/app_navigation_screen.dart';
//import 'package:mally/presentation/photo_four_screen/photo_four_screen.dart';
//import 'package:mally/presentation/photo_one_screen/photo_one_screen.dart';
//import 'package:mally/presentation/photo_three_screen/photo_three_screen.dart';
import 'package:mally/theme/theme_helper.dart';
import 'package:mally/routes/app_routes.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'presentation/home_screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
//import 'presentation/foodScreen/foodScreen.dart';

List<CameraDescription> cameras = [];

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'mally',
      debugShowCheckedModeBanner: false,
      //initialRoute: AppRoutes.homeScreen,
      routes: AppRoutes.routes,
      home: TestPathScreen()//const TestPathScreen()//HomePlusScreen()//HomeScreen(cameras: cameras)///PhotoThreeScreen()//const FoodCategoryScreen(),//HomeScreen(cameras: cameras),
    );
  }
}
