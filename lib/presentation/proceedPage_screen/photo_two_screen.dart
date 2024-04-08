import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mally/core/app_export.dart';
import 'package:mally/widgets/custom_elevated_button.dart';

class PhotoTwoScreen extends StatelessWidget {
  const PhotoTwoScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final pathOfImage = arguments['data'] as String;
    final shopName = arguments['shopName'] as String;
    File? selectedImage;
    selectedImage = File(pathOfImage);
    
    
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 14.v),
                child: Column(children: [
                  selectedImage != null ? Image.file(selectedImage) : const Text('Selected Image'),
                  /*CustomImageView(
                      imagePath: pathOfImage,
                      height: 579.v,
                      width: 393.h),*/
                  SizedBox(height: 30.v),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95, // Set max width to 80% of screen width
                    ),
                    child: Text(
                      "You are currently at $shopName. \n Do you wish to proceed?",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ) //theme.textTheme.titleMedium,
                       
                    ),
                  ),
                  
                  SizedBox(height: 30.v),
                  _buildProceedButtons(context),
                  SizedBox(height: 5.v)
                ])),
            bottomNavigationBar: _buildNavbar(context)));
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
        margin: EdgeInsets.only(left: 65.h, right: 59.h, bottom: 15.v),
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
              Column(mainAxisSize: MainAxisSize.min, children: [
                CustomImageView(
                    imagePath: ImageConstant.imgIconCameraOnprimary,
                    height: 24.adaptSize,
                    width: 24.adaptSize),
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
  /*
  sendToServer(){
    try{
      String filename = this.img!.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(this.img!.path, filename: filename, contentType: MediaType('image', 'jpeg')),
      });
      dio.post(
        'https://mall-ml-model.lm.r.appspot.com:5001/photos/',
         data: formData,
         options: Options(
          headers: {"Content-Type": "multipart/form-data"},
          method: 'POST',
          responseType: ResponseType.json,
         )
      ).then((response) => print(response)).catchError((error) => print(error));
    }catch(e){
      print(e);
    }
  }*/

  /// Navigates to the photoOneScreen when the action is triggered.
  onTapCANCEL(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.testCamera);
  }

  /// Navigates to the photoThreeScreen when the action is triggered.
  onTapPROCEED(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.photoThreeScreen);
  }

  /// Navigates to the homeScreen when the action is triggered.
  onTapFrameThree(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.homeScreen);
  }

  /// Navigates to the profileScreen when the action is triggered.
  onTapFrameOne(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }
}
