import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mally/core/app_export.dart';
import 'package:mally/widgets/false_custom_search_view.dart';
bool counter = false;

// ignore_for_file: must_be_immutable
class TestPathScreen extends StatefulWidget {
  TestPathScreen({super.key});

  @override
  State<TestPathScreen> createState() => _TestPathScreenState();
}

class _TestPathScreenState extends State<TestPathScreen> {
  Uint8List? imageBytes1;
  Uint8List? imageBytes2;
  late Uint8List? imageBytesToShow = ogImageBytes1;
  Uint8List? ogImageBytes0;
  Uint8List? ogImageBytes1;
  Uint8List? ogImageBytes2;
  
  TextEditingController searchController = TextEditingController();

  // Variable to keep track of the currently selected button
  int _selectedButtonIndex = 1;

  @override
  void initState() {
    super.initState();
    //if (counter == false){
      imageToBytes();
      counter = true;
    //}
  }

  void imageToBytes() async{
    // Load image asset as bytes
    ByteData imageData0 = await rootBundle.load('assets/images/ZeroFloor.png');
    ogImageBytes0 = imageData0.buffer.asUint8List();
    ByteData imageData1 = await rootBundle.load('assets/images/FirstFloor1.png');
    ogImageBytes1 = imageData1.buffer.asUint8List();
    ByteData imageData2 = await rootBundle.load('assets/images/SecondFloor.png');
    ogImageBytes2 = imageData2.buffer.asUint8List();

    setState(() {
      imageBytesToShow = ogImageBytes1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      imageBytes1 = arguments['image2'] as Uint8List?;
      imageBytes2 = arguments['image1'] as Uint8List?;
    }
    
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Expanded(child: _buildPhotoThree(context)),
            bottomNavigationBar: _buildNavbar(context)));
  }

  /// Section Widget
  Widget _buildPhotoThree(BuildContext context) {
    return Stack(
        children: [
          //Picture panel
          Positioned.fill(
            child: InteractiveViewer(
              child: Container(
                decoration: imageBytesToShow != null
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(imageBytesToShow!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
                alignment: Alignment.center,
              ),
            ),
          ),
          //SearchBar panel
          /* Positioned(
            top: 30, // Adjust this value according to your layout
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.testSearch); //need to add argument here
                },
                child: FalseCustomSearchView(
                  controller: searchController, hintText: "Search"),
              ),
            )
          ), */
          // Buttons Panel
          Positioned(
            top: 0,
            bottom: 25,
            right: 9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedButtonIndex = 2;
                        if(imageBytes2 == null){
                          imageBytesToShow = ogImageBytes2;
                        }else{
                          imageBytesToShow = imageBytes1;
                        }
                        
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: _selectedButtonIndex == 2
                          ? MaterialStateProperty.all<Color>(Colors.green)
                          : null,
                      minimumSize: MaterialStateProperty.all(const Size(64, 64)),
                      shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder(),
                      ),
                    ),
                    child: Text(
                      '2',
                      textScaler: const TextScaler.linear(1.4),
                      style: TextStyle(
                        color: _selectedButtonIndex == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedButtonIndex = 1;
                        if(imageBytes1 == null){
                          imageBytesToShow = ogImageBytes1;
                        }else{
                          imageBytesToShow = imageBytes2;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: _selectedButtonIndex == 1
                          ? MaterialStateProperty.all<Color>(Colors.green)
                          : null,
                      minimumSize: MaterialStateProperty.all(const Size(64, 64)),
                      shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder(),
                      ),
                    ),
                    child: Text(
                      '1',
                      textScaler: const TextScaler.linear(1.4),
                      style: TextStyle(
                        color: _selectedButtonIndex == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedButtonIndex = 0;
                        if(imageBytes1 == null){
                          imageBytesToShow = ogImageBytes0;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: _selectedButtonIndex == 0
                          ? MaterialStateProperty.all<Color>(Colors.green)
                          : null,
                      minimumSize: MaterialStateProperty.all(const Size(64, 64)),
                      shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder(),
                      ),
                    ),
                    child: Text(
                      '0',
                      textScaler: const TextScaler.linear(1.4),
                      style: TextStyle(
                        color: _selectedButtonIndex == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
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
                        imagePath: ImageConstant.imgIconMap,
                        height: 24.adaptSize,
                        width: 24.adaptSize),
                    Padding(
                        padding: EdgeInsets.only(top: 13.v),
                        child: Text("Map", style: CustomTextStyles.labelLargeOnPrimary))
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