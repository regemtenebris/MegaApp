import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mally/core/app_export.dart';
import 'package:mally/widgets/custom_elevated_button.dart';

class PhotoTwoScreen extends StatefulWidget {
  const PhotoTwoScreen({super.key});

  @override
  State<PhotoTwoScreen> createState() => _PhotoTwoScreenState();
}

class _PhotoTwoScreenState extends State<PhotoTwoScreen> {
  var startName = '';
  
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final pathOfImage = arguments['data'] as String;
    startName = arguments['shopName'] as String;
    File? selectedImage;
    selectedImage = File(pathOfImage);
    
    
    mediaQueryData = MediaQuery.of(context);
    return PopScope(
      canPop: false,
      child: SafeArea(
          child: Scaffold(
              body: Container(
                color: const Color(0xFF111111),
                  width: double.infinity,
                  //padding: EdgeInsets.symmetric(vertical: 14.v),
                  child: Column(
                    children: [
                      selectedImage != null 
                      ? Container(
                          width: 395, 
                          height: 540, 
                          child: Image.file(
                            selectedImage, 
                            fit: BoxFit.cover
                          )
                        )
                      : const Text('Selected Image'),
                      SizedBox(height: 30.v),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.95, // Set max width to 80% of screen width
                        ),
                        child: Text(
                          "You are currently at $startName. \n Do you wish to proceed?",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color:  Color(0xFFFFFFFF)
                          ) //theme.textTheme.titleMedium,
                          
                        ),
                      ),
                      
                      SizedBox(height: 30.v),
                      _buildProceedButtons(context),
                      SizedBox(height: 5.v)
          ])),
              bottomNavigationBar: _buildNavbar(context))),
    );
  }

  /// Section Widget
  Widget _buildProceedButtons(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomElevatedButton(
              height: 41.v,
              width: 150.h,
              text: "CANCEL",
              onPressed: () {
                onTapCANCEL(context);
              }),
          CustomElevatedButton(
              height: 41.v,
              width: 150.h,
              text: "PROCEED",
              margin: EdgeInsets.only(left: 29.h),
              buttonStyle: CustomButtonStyles.fillGreenA,
              onPressed: () {
                //sendToServer();
                onTapPROCEED(context);
              })
        ]));
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
                width: 24.adaptSize),
              Padding(
                padding: EdgeInsets.only(top: 13.v),
                child: Text("Map", style: theme.textTheme.labelLarge))
            ])),
            const Spacer(flex: 51),
            Column(mainAxisSize: MainAxisSize.min, children: [
            CustomImageView(
              imagePath: ImageConstant.imgIconCameraOnprimary,
              height: 24.adaptSize,
              width: 24.adaptSize,
              color: const Color(0xFFFFFFFF),),
            Padding(
              padding: EdgeInsets.only(top: 11.v),
              child: Text("Photo",
                style: CustomTextStyles.labelLargeOnPrimary))
                        ]),
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

  /// Navigates to the photoOneScreen when the action is triggered.
  onTapCANCEL(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.testCamera);
  }

  /// Navigates to the photoThreeScreen when the action is triggered.
  onTapPROCEED(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.photoThreeScreen, arguments: {'startName' : startName});
  }

  /// Navigates to the homeScreen when the action is triggered.
  onTapFrameThree(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.testPath);
  }

  /// Navigates to the profileScreen when the action is triggered.
  onTapFrameOne(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }
}
