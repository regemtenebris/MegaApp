import 'package:flutter/material.dart';
import 'package:mally/core/app_export.dart';
import 'package:mally/widgets/app_bar/appbar_title.dart';
import 'package:mally/widgets/app_bar/custom_app_bar.dart';
import 'package:mally/widgets/custom_search_view.dart';
import 'package:mally/widgets/false_custom_search_view.dart';

// ignore: must_be_immutable
class PhotoThreeScreen extends StatelessWidget {
  PhotoThreeScreen({super.key});

  final List<Color> colors = [
    const Color(0xff084E25),
    const Color(0xff0B636B),
    const Color(0xff0E896A),
    const Color(0xff2E6B5C),
    const Color(0xff01426D),
    const Color(0xff0A6110),
  ];
  
  final Map<String, String> categoryRoutes = {
    'Food': AppRoutes.foodScreen,
    'Clothes': '/photo_five_screen',
    'Accessories & Jewellery': AppRoutes.accessoriesCategoryScreen,
    'Photo': AppRoutes.photoCategoryScreen,
    'Technology': AppRoutes.technologyScreen,
    'Cars': AppRoutes.carsCategoryScreen,
    'Health': AppRoutes.healthScreen,
    'Grocery': AppRoutes.groceryScreen,
    'Beauty': AppRoutes.beautyScreen,
    'Connection Providers': AppRoutes.connectionScreen,
    'Banks': AppRoutes.banksScreen,
    'Smoking': AppRoutes.smokingScreen,
    'Other': AppRoutes.otherScreen,
  };

  TextEditingController searchController = TextEditingController();
  String startName = '';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    startName = arguments['startName'] as String;

    mediaQueryData = MediaQuery.of(context);
    return PopScope(
      canPop: false,
      child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: _buildAppBar(context),
              body: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 22.h),
                  child: Column(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.testSearch, arguments: {'startName' : startName});
                      },
                      child: FalseCustomSearchView(
                        controller: searchController, hintText: "Search"),
                    ),
                    SizedBox(height: 30.v),
                    Expanded(child: _buildPhotoThree(context))
                  ])),
              bottomNavigationBar: _buildNavbar(context))),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        centerTitle: true,
        title: AppbarTitle(text: "Where do you want to go?"));
  }

  /// Section Widget
  Widget _buildPhotoThree(BuildContext context) {
    return GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 180.v,
            crossAxisCount: 2,
            mainAxisSpacing: 15.h,
            crossAxisSpacing: 15.h),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final color = colors[index % colors.length];
            return InkWell(
              onTap: () {
                final routeName = categoryRoutes[category.title];
                  if (routeName != null) {
                    Navigator.pushNamed(context, routeName, arguments: {'data' : category.title, 'startName' : startName});
                  }
                },
              child: Card(
                color: color,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(category.title, style: const TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              ),
            );
          }
        );
  }

  /// Section Widget
  Widget _buildNavbar(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 65.h, right: 59.h, bottom: 10.v, top: 15.v),
        decoration:
            BoxDecoration(borderRadius: BorderRadiusStyle.roundedBorder15),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: () {
                    onTapFrameThree(context);
                  },
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    CustomImageView(
                        imagePath: ImageConstant.imgIconMapPrimary,
                        height: 24.adaptSize,
                        width: 24.adaptSize),
                    Padding(
                        padding: EdgeInsets.only(top: 13.v),
                        child: Text("Map", style: theme.textTheme.labelLarge))
                  ])),
              const Spacer(flex: 51),
              GestureDetector(
                  onTap: () {
                    onTapFrameTwo(context);
                  },
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                CustomImageView(
                    imagePath: ImageConstant.imgIconCamera,
                    height: 24.adaptSize,
                    width: 24.adaptSize),
                Padding(
                    padding: EdgeInsets.only(top: 11.v),
                    child: Text("Photo",
                        style: theme.textTheme.labelLarge))
              ])),
              const Spacer(flex: 48),
              GestureDetector(
                  onTap: () {
                    onTapFrameOne(context);
                  },
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    CustomImageView(
                        imagePath: ImageConstant.imgIconUser,
                        height: 24.adaptSize,
                        width: 24.adaptSize),
                    Padding(
                        padding: EdgeInsets.only(top: 11.v),
                        child:
                            Text("Profile", style: theme.textTheme.labelLarge))
                  ]))
            ]));
  }

  /// Navigates to the homeScreen when the action is triggered.
  onTapFrameThree(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.testPath);
  }

  /// Navigates to the photoOneScreen when the action is triggered.
  onTapFrameTwo(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.testCamera);
  }

  /// Navigates to the profileScreen when the action is triggered.
  onTapFrameOne(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }
}

class Category {
  final String id;
  final String title;

  Category({required this.id, required this.title});
}

// Create a list of dummy categories
List<Category> categories = [
  Category(id: '1', title: 'Food'),
  Category(id: '2', title: 'Clothes'),
  Category(id: '3', title: 'Accessories & Jewellery'),
  Category(id: '4', title: 'Photo'),
  Category(id: '5', title: 'Technology'),
  Category(id: '6', title: 'Cars'),
  Category(id: '7', title: 'Health'),
  Category(id: '8', title: 'Grocery'),
  Category(id: '9', title: 'Beauty'),
  Category(id: '10', title: 'Connection Providers'),
  Category(id: '11', title: 'Banks'),
  Category(id: '12', title: 'Smoking'),
  Category(id: '13', title: 'Other'),
]; 