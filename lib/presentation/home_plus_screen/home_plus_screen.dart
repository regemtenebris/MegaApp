
import 'package:flutter/material.dart';
import 'package:mally/core/app_export.dart';
import 'package:mally/widgets/false_custom_search_view.dart';

// ignore: must_be_immutable
class HomePlusScreen extends StatefulWidget {
  const HomePlusScreen({super.key});

  @override
  State<HomePlusScreen> createState() => _HomePlusScreenState();
}

class _HomePlusScreenState extends State<HomePlusScreen> {
  TextEditingController searchController = TextEditingController();

  // Variable to keep track of the currently selected button
  int _selectedButtonIndex = 1;

  // Background images for each button
  final List<String> _backgroundImages = [
    'assets/images/ZeroFloor.png',
    'assets/images/FirstFloor1.png',
    'assets/images/SecondFloor.png',
  ];

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset(
                _backgroundImages[_selectedButtonIndex],
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          //SearchBar panel
          Positioned(
            top: 30, // Adjust this value according to your layout
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.testSearch);
                },
                child: FalseCustomSearchView(
                  controller: searchController, hintText: "Search"),
              ),
            )
          ),
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
                        _selectedButtonIndex = 0;
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedButtonIndex = 1;
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
                        _selectedButtonIndex = 2;
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
              ],
            ),
          ),
        ]
    );
    /* Row(
      children: [
        // Button panel
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: double.infinity),
          child: Container(
            width: 50,
            height: double.infinity,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    buildNumberButton(0),
                    const SizedBox(height: 5),
                    buildNumberButton(1),
                    const SizedBox(height: 5),
                    buildNumberButton(2),
                  ],
                )
              ]
            ),
          ),
        ),
        // Image display
        Expanded(
          flex: 3,
          child: InteractiveViewer(
            child: Image.asset(_currentImage),
          ),
        ),
      ],
    ); */
  }

  /// Section Widget
  Widget _buildNavbar(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 65.h, right: 59.h, bottom: 10.v, top: 10.v),
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
                    imagePath: ImageConstant.imgIconCameraOnprimary,
                    height: 24.adaptSize,
                    width: 24.adaptSize),
                Padding(
                    padding: EdgeInsets.only(top: 11.v),
                    child: Text("Photo",
                        style: CustomTextStyles.labelLargeOnPrimary))
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
    Navigator.pushNamed(context, AppRoutes.homeScreen);
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