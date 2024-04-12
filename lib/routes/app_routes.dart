import 'package:flutter/material.dart';
import 'package:mally/main.dart';
import 'package:mally/presentation/screenAccessories/accessoriesScreen.dart';
import 'package:mally/presentation/screenBanks/banksScreen.dart';
import 'package:mally/presentation/screenBeauty/beautyScreen.dart';
import 'package:mally/presentation/screenCarsCategory/carsCategoryScreen.dart';
import 'package:mally/presentation/home_screen/home_screen.dart';
import 'package:mally/presentation/screenClothes/ClothesScreen.dart';
import 'package:mally/presentation/screenConnection/connectionScreen.dart';
import 'package:mally/presentation/screenGrocery/groceryScreen.dart';
import 'package:mally/presentation/screenHealth/healthScreen.dart';
import 'package:mally/presentation/screenOther/otherScreen.dart';
import 'package:mally/presentation/screenPhotoCategory/photoCategoryScreen.dart';
import 'package:mally/presentation/photo_six_screen/photo_six_screen.dart';
import 'package:mally/presentation/home_plus_screen/home_plus_screen.dart';
import 'package:mally/presentation/category_screen/photo_three_screen.dart';
import 'package:mally/presentation/photo_four_screen/photo_four_screen.dart';
import 'package:mally/presentation/camera_screen/photo_one_screen.dart';
import 'package:mally/presentation/profile_screen/profile_screen.dart';
import 'package:mally/presentation/proceedPage_screen/photo_two_screen.dart';
import 'package:mally/presentation/screenSmoking/smokingScreen.dart';
import 'package:mally/presentation/screenTechnology/technologyScreen.dart';
import 'package:mally/presentation/app_navigation_screen/app_navigation_screen.dart';
import 'package:mally/presentation/testPath/testPath.dart';
import 'package:mally/presentation/testSearch/testSearch.dart';
import 'package:mally/presentation/screenFood/FoodScreen.dart';
import 'package:mally/presentation/testcamera/testCamera.dart';

class AppRoutes {
  static const String homeScreen = '/home_screen';

  static const String photoFiveScreen = '/photo_five_screen';

  static const String photoSixScreen = '/photo_six_screen';

  static const String homePlusScreen = '/home_plus_screen';

  static const String photoThreeScreen = '/photo_three_screen';

  static const String photoFourScreen = '/photo_four_screen';

  static const String photoOneScreen = '/photo_one_screen';

  static const String profileScreen = '/profile_screen';

  static const String photoTwoScreen = '/photo_two_screen';

  static const String technologyScreen = '/technologyScreen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String foodScreen= '/foodScreen';
  
  static const String accessoriesCategoryScreen = '/accessoriesScreen';

  static const String photoCategoryScreen = '/photoCategoryScreen';

  static const String carsCategoryScreen = '/carsCategoryScreen';

  static const String healthScreen = '/healthScreen';

  static const String groceryScreen = '/groceryScreen';

  static const String beautyScreen = '/beautyScreen';

  static const String connectionScreen = '/connectionScreen';

  static const String banksScreen = '/banksScreen';

  static const String smokingScreen = '/smokingScreen';

  static const String otherScreen = '/otherScreen';

  static const String testCamera = '/testCamera';

  static const String testSearch = '/testSearch';

  static const String testPath = '/testPath';

  static Map<String, WidgetBuilder> routes = {
    homeScreen: (context) => HomeScreen(cameras: cameras,),
    photoFiveScreen: (context) => ClothesScreen(),
    photoSixScreen: (context) => const PhotoSixScreen(),
    homePlusScreen: (context) => TestPathScreen(),
    photoThreeScreen: (context) => PhotoThreeScreen(),
    photoFourScreen: (context) => PhotoFourScreen(),
    photoOneScreen: (context) => PhotoOneScreen(cameras),
    profileScreen: (context) => const ProfileScreen(),
    photoTwoScreen: (context) => const PhotoTwoScreen(),
    technologyScreen: (context) => const TechnologyScreen(),
    appNavigationScreen: (context) => const AppNavigationScreen(),
    foodScreen: (context) => TestSearchScreen(),
    accessoriesCategoryScreen: (context) => const AccessoriesCategoryScreen(),
    photoCategoryScreen: (context) => const PhotoCategoryScreen(),
    carsCategoryScreen: (context) => const CarsCategoryScreen(),
    healthScreen: (context) => const HealthCategoryScreen(),
    groceryScreen: (context) => const GroceryCategoryScreen(),
    beautyScreen: (context) => const BeautyCategoryScreen(),
    connectionScreen: (context) => const ConnectionCategoryScreen(),
    banksScreen: (context) => const BanksCategoryScreen(),
    smokingScreen: (context) => const SmokingCategoryScreen(),
    otherScreen: (context) => const OtherCategoryScreen(),
    testCamera: (context) => TestCameraScreen(cameras),
    testSearch: (context) => const MySearchPage(),
    testPath: (context) => const HomePlusScreen(),
  };
}
