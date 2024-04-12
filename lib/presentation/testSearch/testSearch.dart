import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mally/core/app_export.dart';
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
  Uint8List? imageBytes1;
  Uint8List? imageBytes2;
  var startName = '';
  var destName = '';
  
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
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    startName = arguments['startName'] as String;

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

  //concurency version, but list is not stable
  Future<void> getFoodShops() async {
    // Initialize Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a list to hold futures
    List<Future<void>> futures = [];

    // Add each document's data fetching future to the list
    for (int i = 0; i < 3; i++) {
      futures.add(fetchDataForDocument(firestore, i));
    }
    // Wait for all futures to complete
    await Future.wait(futures);
    setState(() {
      _searchResult.addAll(foodShopsDocuments);
    });
  }

  Future<void> fetchDataForDocument(FirebaseFirestore firestore, int documentIndex) async {
    try {
    // Fetch the document
    DocumentSnapshot document = await firestore.collection('Shops').doc('$documentIndex').get();

    // Check if the document exists
    if (document.exists) {
      // Fetch stores subcollection data
      QuerySnapshot storesSnapshot = await document.reference.collection('Stores').get();

      // Process each store
      foodShopsDocuments.addAll(storesSnapshot.docs);
      /* for (QueryDocumentSnapshot document in foodShopsDocuments) {
        print('Shop Name: ${document.id}');
        print('Category: ${document['Category']}');
        print('Description: ${document['Description']}');
        print('Picture: ${document['Picture']}');
        // Add your logic here
      } */
    } else {
      print('Document $documentIndex does not exist.');
    }
    } catch (error) {
      print('Error fetching data for document $documentIndex: $error');
    }
  }

  //linear version, without concurency, but list is stable
 /*  Future<void> getFoodShops() async {
  // Start the stopwatch
    Stopwatch stopwatch = Stopwatch()..start();
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
      // Stop the stopwatch
    stopwatch.stop();

    // Get the elapsed time
    print('Time taken: ${stopwatch.elapsedMilliseconds} milliseconds');
  } */

  Future sendToPathServer(startShop, destShop) async{
    int? startID = shopsMap[startShop];
    int? destID = shopsMap[destShop];
    print("startName is: $startShop");
    print("destName is: $destShop");
    print("startID is: $startID");
    print("destID is: $destID");
    try {
      final Map<String, int?> data = {
        "start": startID,
        "finish": destID,
      };
      String jsonBody = jsonEncode(data);

      var response = await http.post(
        Uri.parse('https://mall-ml-model.lm.r.appspot.com/path/'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
        body: jsonBody
      );
      print(jsonBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        // Assuming server returns images as base64 strings
        String? imageString2 = jsonResponse['image1'];
        String? imageString1 = jsonResponse['image2'];
        print(imageString1);
        print(imageString2);
        if (imageString1 != null && imageString2 != null) {
          setState(() {
            imageBytes2 = base64.decode(imageString1);
            imageBytes1 = base64.decode(imageString2);
          });
        }
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, AppRoutes.homePlusScreen, arguments: { 'image1': imageBytes1, 'image2': imageBytes2});
      } else {
        throw Exception('Failed to fetch data from server');
      }
    }catch(e){
      print(e);
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
              destName = _searchResult[index].id;
              print(destName);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('', textScaler: TextScaler.linear(0.5)),
                    content: Text('You chose $destName as destination. Do you wish to proceed?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Send to server
                          sendToPathServer(startName, destName);
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text('Proceed'),
                      ),
                    ],
                  );
                },
              );
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

Map<String, int> shopsMap = {
  '33 pingvina': 0,
'7Life': 1,
'ActualOptic': 2,
'Adika': 3,
'Adili': 4,
'AllOff': 5,
'AltynAlan': 6,
'AlyeParusa': 7,
'AngelinUs1': 8,
'Anime Shop': 9,
'ArmaniExchange': 10,
'Askona': 11,
'Atelie': 12,
'Auz Tea': 13,
'Avanti': 14,
'Avrora1': 15,
'BIGroup': 16,
'Bahandi': 17,
'Balausa': 18,
'Bambino': 19,
'Bao': 20,
'Basconi': 21,
'Baskin Robbins': 22,
'BearRichi': 23,
'Beautymania': 24,
'Beeline': 25,
'Bereke Bank': 26,
'Bershka': 27,
'Billion Co': 28,
'BlackStarBurger': 29,
'BobbyBrown': 30,
'BodyShop': 31,
'Bogachie': 32,
'Bro': 33,
'Bronoskins': 34,
'BurgerKing': 35,
'CalvinKleinJeans': 36,
'Calzedonia': 37,
'CasaMore': 38,
'Chapeau': 39,
'Chaplin Cinemas': 40,
'Chic': 41,
'Chullok': 42,
'City Men': 43,
'Climber': 44,
'Coffee Day': 45,
'CoffeeBoom': 46,
'Colins': 47,
'Columbia': 48,
'Cossmo': 49,
'Creperie de Paris': 50,
'Crocs': 51,
'DanielRizotto': 52,
'DeFacto': 53,
'Delish': 54,
'Diesel': 55,
'Dodo Pizza': 56,
'Doro': 57,
'DossoDossi': 58,
'Dyson': 59,
'Ecco': 60,
'Eco Glow': 61,
'Eco Home': 62,
'EcoClean': 63,
'Eliks': 64,
'EmilioGuido': 65,
'Epl': 66,
'Espresso Day': 67,
'Evrikum': 68,
'Fabiani': 69,
'Fagum': 70,
'Farsh': 71,
'Flo2': 72,
'Food Park': 73,
'Footie': 74,
'ForteBank': 75,
'Frato': 76,
'Freedom Mobile': 77,
'FrenchHouse': 78,
'Fruit Republic': 79,
'G-Shock': 80,
'Gaissina': 81,
'Galmart': 82,
'Gant': 83,
'Geox': 84,
'Glasman': 85,
'Glo': 86,
'Global Coffee': 87,
'Global Nomads': 88,
'GloriaJeans': 89,
'Guess': 90,
'Gulliver': 91,
'HM': 92,
'HalykBank': 93,
'HappyShoes': 94,
'Happylon': 95,
'Hardees': 96,
'HeyBaby': 97,
'Home Credit Bank': 98,
'Hugo': 99,
'Im': 100,
'Imperia Meha': 101,
'Injoy': 102,
'Inspire': 103,
'Instax': 104,
'Intertop': 105,
'Intimissimi': 106,
'Iqos': 107,
'Izbushka': 108,
'JackJones': 109,
'Jo Malone': 110,
'Jol': 111,
'Jolie': 112,
'Josiny': 113,
'Jusan': 114,
'KFC': 115,
'Kango': 116,
'Kanzler': 117,
'Kari': 118,
'Kaztour': 119,
'Keddo': 120,
'Kedma': 121,
'Kelzin': 122,
'Khan Mura': 123,
'Kids Art': 124,
'Kimex': 125,
'Kitikate': 126,
'KoreanHouse': 127,
'Kotofei': 128,
'Koton1': 129,
'L-Shoes': 130,
'LCWaikiki1': 131,
'LaVerna': 132,
'Lacoste': 133,
'LadyCollection': 134,
'Lazania': 135,
'Lee': 136,
'Leonardo': 137,
'LepimVarim': 138,
'Lero': 139,
'Levis': 140,
'Lichi': 141,
'Lining': 142,
'Loccitane': 143,
'LoveRepublic': 144,
'Lshoes': 145,
'Lucky Donuts': 146,
'Luxe': 147,
'Mac': 148,
'MadameCoco': 149,
'Majorica': 150,
'Mango': 151,
'MarcoPolo': 152,
'MarkFormelle': 153,
'MarroneRosso': 154,
'Marwin': 155,
'MassimoDutti': 156,
'McDonalds': 157,
'Mega Arena': 158,
'Mega Motors': 159,
'Mega Studio': 160,
'Mellis': 161,
'Mi': 162,
'MilaVitsa': 163,
'Mimioriki': 164,
'MiniCity': 165,
'Miniso': 166,
'Miuz': 167,
'Mixit': 168,
'Mobiland': 169,
'Monaco': 170,
'Mone': 171,
'Mothercare': 172,
'NewYorker': 173,
'Next': 174,
'NickolBeauty': 175,
'Nike': 176,
'Nomad': 177,
'NorthFace': 178,
'Nyx': 179,
'OceanBasket': 180,
'Oh My Gold': 181,
'Okaidi': 182,
'Orchestra': 183,
'Ostin1': 184,
'Oysho': 185,
'Pablo': 186,
'Pandora': 187,
'Parfume de Vie': 188,
'Paul': 189,
'Penti': 190,
'Pharmacom': 191,
'Pinta': 192,
'Pivovaroff': 193,
'Plum Tea': 194,
'Podium': 195,
'PullBear': 196,
'Punto': 197,
'QazaqRepublic': 198,
'Reima': 199,
'Respect': 200,
'RitzyFasion': 201,
'Roberto Bravo': 202,
'Rumi': 203,
'SBF': 204,
'Sabville': 205,
'Saem': 206,
'Salomon': 207,
'Samsonite': 208,
'Sara Fashion': 209,
'Satty Zhuldyz': 210,
'Sberbank': 211,
'Shapo': 212,
'Shopogolik': 213,
'Silkway Beauty': 214,
'Skechers': 215,
'Sman': 216,
'SmartTel': 217,
'Solido': 218,
'SonyCentre': 219,
'Sportmaster': 220,
'Starbucks1': 221,
'Sterling Silver': 222,
'Stradivarius': 223,
'Superdry': 224,
'Swarovski': 225,
'Sweets': 226,
'Swisstime': 227,
'Taksim': 228,
'Technodom': 229,
'TerraNova': 230,
'The Body Shop': 231,
'Timberland': 232,
'Tissot': 233,
'Tobacco Shop': 234,
'TommyHilfiger': 235,
'Tucino': 236,
'USPoloAssn': 237,
'UlymyrzaHanym': 238,
'UnderArmour': 239,
'Untsia': 240,
'VR Zone': 241,
'Vicco': 242,
'Vitacci': 243,
'Viva': 244,
'WKey': 245,
'Walker': 246,
'Wanex': 247,
'Watch Avenue': 248,
'WhyNot': 249,
'Yakitoriya': 250,
'YamDam': 251,
'Yellow Corn': 252,
'YvesRocher': 253,
'Zara': 254,
'ZaraHome': 255,
'Zebra Coffee': 256,
'Zhekas': 257,
'ZhekasIce': 258,
'ZingalRiche': 259,
'Zolotoye Yabloko': 260,
'iSpace': 261,
};

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