import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mally/core/utils/size_utils.dart';
import 'package:mally/widgets/custom_search_view.dart';

List<QueryDocumentSnapshot> foodShopsDocuments = List.empty(growable: true);
bool counter = false;
String categoryName = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(const MySearchPage());
}

class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key});

  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
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

  @override
  Widget build(BuildContext context) {
    if (counter == false){
      getFoodShops();
      counter = true;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 22.h),
                child: Column(
                  children: [
                    CustomSearchView(
                      controller: _searchController, hintText: "Search",
                      onChanged: (value) => _onSearchChanged(value)
                    ),
                    SizedBox(height: 30.v),
                    Expanded(child: _buildPhotoThree(context))
                ]))
    );
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
      QuerySnapshot foodShopsSnapshot = await storesCollection.get();

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
}

/*line 47 
    Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 22.h),
        child: Column(
          children: [
            CustomSearchView(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResult.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResult[index]),
                    // Add more ListTile customization as needed
                  );
                },
              ),
            ),
          ],
        ),
      ), */
List<String> _shops = [
  '33 pingvina',
  '7Life',
  'ActualOptic',
  'Adika',
  'Adili',
  'AllOff',
  'AltynAlan',
  'AlyeParusa',
  'AngelinUs2',
  'AngelinUs1',
  'Anime Shop',
  'ArmaniExchange',
  'Askona',
  'Atelie',
  'Auz Tea',
  'Avanti',
  'Avrora1',
  'Avrora2',
  'BIGroup',
  'Bahandi',
  'Balausa',
  'Bambino',
  'Bao',
  'Basconi',
  'Baskin Robbins',
  'BearRichi',
  'Beautymania',
  'Beeline',
  'Bereke Bank',
  'Bershka',
  'Billion Co',
  'BlackStarBurger',
  'BobbyBrown',
  'BodyShop',
  'Bogachie',
  'Bro',
  'Bronoskins',
  'BurgerKing',
  'CalvinKleinJeans',
  'Calzedonia',
  'CasaMore',
  'Chapeau',
  'Chaplin Cinemas',
  'Chic',
  'Chullok',
  'City Men',
  'Climber',
  'Coffee Day',
  'CoffeeBoom',
  'Colins',
  'Columbia',
  'Cossmo',
  'Creperie de Paris',
  'Crocs',
  'DanielRizotto',
  'DeFacto',
  'Delish',
  'Diesel',
  'Dodo Pizza',
  'Doro',
  'DossoDossi',
  'Dyson',
  'Ecco',
  'Eco Glow',
  'Eco Home',
  'EcoClean',
  'Eliks',
  'EmilioGuido',
  'Epl',
  'Espresso Day',
  'Evrikum',
  'Fabiani',
  'Fagum',
  'Farsh',
  'Flo2',
  'Food Park',
  'Footie',
  'ForteBank',
  'Frato',
  'Freedom Mobile',
  'FrenchHouse',
  'Fruit Republic',
  'G-Shock',
  'Gaissina',
  'Galmart',
  'Gant',
  'Geox',
  'Glasman',
  'Glo',
  'Global Coffee',
  'Global Nomads',
  'GloriaJeans',
  'Guess',
  'Gulliver',
  'HM',
  'HalykBank',
  'HappyShoes',
  'Happylon',
  'Hardees',
  'HeyBaby',
  'Home Credit Bank',
  'Hugo',
  'Im',
  'Imperia Meha',
  'Injoy',
  'Inspire',
  'Instax',
  'Intertop',
  'Intimissimi',
  'Iqos',
  'Izbushka',
  'JackJones',
  'Jo Malone',
  'Jol',
  'Jolie',
  'Josiny',
  'Jusan',
  'KFC',
  'Kango',
  'Kanzler',
  'Kari',
  'Kaztour',
  'Keddo',
  'Kedma',
  'Kelzin',
  'Khan Mura',
  'Kids Art',
  'Kimex',
  'Kitikate',
  'KoreanHouse',
  'Kotofei',
  'Koton1',
  'Koton2',
  'L-Shoes',
  'LCWaikiki1',
  'LCWaikiki2',
  'LaVerna',
  'Lacoste',
  'LadyCollection',
  'Lazania',
  'Lee',
  'Leonardo',
  'LepimVarim',
  'Lero',
  'Levis',
  'Lichi',
  'Lining',
  'Loccitane',
  'LoveRepublic',
  'Lshoes',
  'Lucky Donuts',
  'Luxe',
  'Mac',
  'MadameCoco',
  'Majorica',
  'Mango',
  'MarcoPolo',
  'MarkFormelle',
  'MarroneRosso',
  'Marwin',
  'MassimoDutti',
  'McDonalds',
  'Mega Arena',
  'Mega Motors',
  'Mega Studio',
  'Mellis',
  'Mi',
  'MilaVitsa',
  'Mimioriki',
  'MiniCity',
  'Miniso',
  'Miuz',
  'Mixit',
  'Mobiland',
  'Monaco',
  'Mone',
  'Mothercare',
  'NewYorker',
  'Next',
  'NickolBeauty',
  'Nike',
  'Nomad',
  'NorthFace',
  'Nyx',
  'OceanBasket',
  'Oh My Gold',
  'Okaidi',
  'Orchestra',
  'Ostin1',
  'Ostin2',
  'Oysho',
  'Pablo',
  'Pandora',
  'Parfume de Vie',
  'Paul',
  'Penti',
  'Pharmacom',
  'Pinta',
  'Pivovaroff',
  'Plum Tea',
  'Podium',
  'PullBear',
  'Punto',
  'QazaqRepublic',
  'Reima',
  'Respect',
  'RitzyFasion',
  'Roberto Bravo',
  'Rumi',
  'SBF',
  'Sabville',
  'Saem',
  'Salomon',
  'Samsonite',
  'Sara Fashion',
  'Satty Zhuldyz',
  'Sberbank',
  'Shapo',
  'Shopogolik',
  'Silkway Beauty',
  'Skechers',
  'Sman',
  'SmartTel',
  'Solido',
  'SonyCentre',
  'Sportmaster',
  'Starbucks1',
  'Starbucks2',
  'Sterling Silver',
  'Stradivarius',
  'Superdry',
  'Swarovski',
  'Sweets',
  'Swisstime',
  'Taksim',
  'Technodom',
  'TerraNova',
  'The Body Shop',
  'Timberland',
  'Tissot',
  'Tobacco Shop',
  'TommyHilfiger',
  'Tucino',
  'USPoloAssn',
  'UlymyrzaHanym',
  'UnderArmour',
  'Untsia',
  'VR Zone',
  'Vicco',
  'Vitacci',
  'Viva',
  'WKey',
  'Walker',
  'Wanex',
  'Watch Avenue',
  'WhyNot',
  'Yakitoriya',
  'YamDam',
  'Yellow Corn',
  'YvesRocher',
  'Zara',
  'ZaraHome',
  'Zebra Coffee'
];

/*import 'package:cloud_firestore/cloud_firestore.dart';
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
  runApp(FoodCategoryScreen());
}

// ignore: must_be_immutable
class FoodCategoryScreen extends StatelessWidget {
  FoodCategoryScreen({super.key});

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
                      controller: searchController, hintText: "Search"),
                  SizedBox(height: 30.v),
                  Expanded(child: _buildPhotoThree(context))
                ])),
            bottomNavigationBar: _buildNavbar(context)));
  }

  /// Section Widget
  Widget _buildPhotoThree(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 105.v,
        crossAxisCount: 1,
        mainAxisSpacing: 5.h),
      itemCount: foodShopsDocuments.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              final shopName = foodShopsDocuments[index].id;
              print(shopName);
            },
            child: Row(
              children: [
                // Image on the left
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(foodShopsDocuments[index]['Picture'].toString(), width: 100.0, height: 80.0),
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
                        foodShopsDocuments[index].id,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 5.0),
                      // Caption 2
                      Text(
                        foodShopsDocuments[index]['Category'],
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
        title: AppbarTitle(text: "Food Category"));
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
}*/