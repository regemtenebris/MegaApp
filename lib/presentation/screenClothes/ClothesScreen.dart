import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mally/core/app_export.dart';
import 'package:mally/widgets/custom_search_view.dart';
import 'package:mally/widgets/app_bar/appbar_title.dart';
import 'package:mally/widgets/app_bar/custom_app_bar.dart';

List<QueryDocumentSnapshot> foodShopsDocuments = List.empty(growable: true);
bool counter = false;
String categoryName = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(ClothesScreen());
}
// ignore: must_be_immutable
class ClothesScreen extends StatefulWidget {
  ClothesScreen({super.key});

  @override
  State<ClothesScreen> createState() => _ClothesScreenState();
}

class _ClothesScreenState extends State<ClothesScreen> {
  late TextEditingController _searchController;

  List<QueryDocumentSnapshot> _searchResult = [];

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
      QuerySnapshot foodShopsSnapshot = await storesCollection.where("Category", isEqualTo: categoryName).get();

      // Access and process the documents in the result
      foodShopsDocuments.addAll(foodShopsSnapshot.docs);
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
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    categoryName = arguments['data'] as String;
    
    if (counter == false){
      getFoodShops();
      counter = true;
    }

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
                  Expanded(child: _buildPhotoThree(context))
                ])),
            bottomNavigationBar: _buildNavbar(context)));
  }

  /// Section Widget
  Widget _buildPhotoThree(BuildContext context) {
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
              final shopName = _searchResult[index].id;
              print(shopName);
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
        title: AppbarTitle(text: "Clothes Category"));
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