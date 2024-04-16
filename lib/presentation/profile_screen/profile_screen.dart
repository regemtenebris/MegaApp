import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mally/core/app_export.dart';
import 'package:mally/widgets/app_bar/appbar_title.dart';
import 'package:mally/widgets/app_bar/custom_app_bar.dart';
import 'package:mally/widgets/custom_search_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _searchController;
  List<QueryDocumentSnapshot> _searchResult = [];
  List<QueryDocumentSnapshot> foodShopsDocuments = List.empty(growable: true);
  String destName = '';
  
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchResult.addAll(foodShopsDocuments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchResult = foodShopsDocuments
          .where((shop) => 
          shop.id.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(context),
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 22.h),
                child: Column(children: [
                  CustomSearchView(
                    controller: _searchController, hintText: "Search",
                    onChanged: (value) => _onSearchChanged(value)
                  ),
                  SizedBox(height: 30.v),
                  Expanded(child: _buildMain(context))
                ])),
            bottomNavigationBar: _buildNavbar(context)));
  }

  Widget _buildMain(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 105.v,
          crossAxisCount: 1,
          mainAxisSpacing: 5.h),
        itemCount: _searchResult.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                destName = _searchResult[index].id;
                print(destName);
              },
              child: Row(
                children: [
                  // Image on the left
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(_searchResult[index]['Picture'].toString(), width: 100.0, height: 80.0),
                  ),
                  const SizedBox(width: 10.0),
                  // Column to stack captions vertically
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Caption 1
                        Text(
                          _searchResult[index].id,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 5.0),
                        // Caption 2
                        Text(
                          _searchResult[index]['Category'],
                          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        centerTitle: true,
        title: AppbarTitle(text: "Favourite Shops"));
  }

  /// Section Widget
  Widget _buildNavbar(BuildContext context) {
    return Container(
        color:const Color(0xFF222222),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 65.h, vertical: 15.v), // Add horizontal padding
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
                width: 24.adaptSize,),
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
              width: 24.adaptSize,
              ),
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
                width: 24.adaptSize,
                color: const Color(0xFFFFFFFF),),
              Padding(
                padding: EdgeInsets.only(top: 11.v),
                child:
                  Text("Profile", style: CustomTextStyles.labelLargeOnPrimary))
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

/*
mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 15.v),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 21.v),
                      CustomImageView(
                          imagePath: ImageConstant.imgImage3,
                          height: 180.adaptSize,
                          width: 180.adaptSize,
                          radius: BorderRadius.circular(90.h),
                          alignment: Alignment.center),
                      SizedBox(height: 17.v),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Kengesbek Alisher",
                              style: CustomTextStyles.headlineSmallOnPrimary)),
                      SizedBox(height: 36.v),
                      Text("Frequently searched",
                          style: theme.textTheme.titleMedium),
                      SizedBox(height: 18.v),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgFrame63,
                                height: 88.adaptSize,
                                width: 88.adaptSize,
                                radius: BorderRadius.circular(15.h)),
                            Container(
                                width: 75.adaptSize,
                                margin:
                                    EdgeInsets.only(left: 22.h, bottom: 21.v),
                                child: Text("Bahandi \n-\nFood",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(height: 1.38)))
                          ]),
                      SizedBox(height: 22.v),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgFrame888x88,
                                height: 88.adaptSize,
                                width: 88.adaptSize,
                                radius: BorderRadius.circular(15.h)),
                            Container(
                                width: 75.h,
                                margin:
                                    EdgeInsets.only(left: 22.h, bottom: 21.v),
                                child: Text("H&M \n- \nClothes",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(height: 1.38)))
                          ]),
                      SizedBox(height: 22.v),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgFrame8,
                                height: 88.adaptSize,
                                width: 88.adaptSize,
                                radius: BorderRadius.circular(15.h)),
                            Container(
                                width: 75.h,
                                margin:
                                    EdgeInsets.only(left: 22.h, bottom: 21.v),
                                child: Text("Berhska \n- \nClothes",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(height: 1.38)))
                          ]),
                      SizedBox(height: 22.v),
                      Row(children: [
                        CustomImageView(
                            imagePath: ImageConstant.imgFrame9,
                            height: 48.v,
                            width: 88.h,
                            radius: BorderRadius.vertical(
                                top: Radius.circular(15.h))),
                        Container(
                            width: 30.h,
                            margin: EdgeInsets.only(left: 22.h, bottom: 3.v),
                            child: Text("KFC \n-\n Food",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(height: 1.38)))
                      ])
                    ])),
            bottomNavigationBar: _buildNavbar(context)));
 */