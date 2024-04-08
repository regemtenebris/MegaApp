//import '../photo_four_screen/widgets/foodlist_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:mally/core/app_export.dart';
import 'package:mally/widgets/custom_search_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

List<QueryDocumentSnapshot> foodShopsDocuments = List.empty(growable: true);
bool counter = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(PhotoFourScreen());
}

// ignore: must_be_immutable
class PhotoFourScreen extends StatelessWidget {
  PhotoFourScreen({super.key});

  TextEditingController searchController = TextEditingController();

  Future<void> getFoodShops() async {
    // Reference to the root collection "Shops"
    CollectionReference shopsCollection = FirebaseFirestore.instance.collection("Shops");

    // Get all documents in the "Shops" collection
    QuerySnapshot shopsSnapshot = await shopsCollection.get();
    //List<QueryDocumentSnapshot> foodShopsDocuments = List.empty(growable: true);
    // Process each document
    for (QueryDocumentSnapshot shopDocument in shopsSnapshot.docs) {
      // Reference to the subcollection "Stores" within each shop document
      CollectionReference storesCollection = shopDocument.reference.collection("Stores");

      // Query documents in the "Stores" subcollection with category equal to "Food"
      QuerySnapshot foodShopsSnapshot = await storesCollection.where("Category", isEqualTo: "Food").get();

      // Access and process the documents in the result
      foodShopsDocuments = foodShopsSnapshot.docs;
      for (QueryDocumentSnapshot document in foodShopsDocuments) {
        print('Shop Name: ${document.id}');
        print('Category: ${document['Category']}');
        print('Description: ${document['Description']}');
        print('Picture: ${document['Picture']}');
        // Add your logic here
      }
    } 
  }

  @override
  Widget build(BuildContext context) {
    if (counter == false){
      getFoodShops();
      counter = true;
    }
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 11.v),
                  child: Column(children: [
                    SizedBox(height: 4.v),
                    Text("Food Category", style: theme.textTheme.titleMedium),
                    SizedBox(height: 6.v),
                    CustomSearchView(
                        controller: searchController, hintText: "Search"),
                    SizedBox(height: 22.v),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            height: 616.v,
                            width: 274.h,
                            child: ListView.builder(
                              itemCount: foodShopsDocuments.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image(
                                            height: 100,
                                            width: 20,
                                            image: NetworkImage(foodShopsDocuments[index]['Picture'].toString())),
                                          Text(foodShopsDocuments[index].id.toString())
                                        ]
                                      )
                                    ]
                                  )
                                );
                              },
                            )
                        )
                    )
                  ])
              ),
              bottomNavigationBar: _buildNavbar(context)
          ),
        );
  }

  /*line 43: Stack(alignment: Alignment.topLeft, children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgFrame62,
                                height: 88.adaptSize,
                                width: 88.adaptSize,
                                radius: BorderRadius.circular(15.h),
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 110.v)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    width: 40.h,
                                    margin: EdgeInsets.only(
                                        left: 110.h, top: 110.v),
                                    child: Text("KFC \n-\nFood",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyLarge!
                                            .copyWith(height: 1.38)))),
                            _buildFoodList(context)
                          ])*/
  /// Section Widget
  /*Widget _buildFoodList(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 132.v);
            },
            itemCount: 5,
            itemBuilder: (context, index) {
              return const FoodlistItemWidget();
            }));
  }*/

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
              GestureDetector(
                  onTap: () {
                    onTapFrameOne(context);
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
