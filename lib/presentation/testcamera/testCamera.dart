import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mally/core/app_export.dart';
import 'package:mally/widgets/app_bar/appbar_title.dart';
import 'package:mally/widgets/app_bar/custom_app_bar.dart';
import 'package:mally/widgets/custom_elevated_button.dart';
import 'package:mally/widgets/false_custom_search_view.dart';

class TestCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const TestCameraScreen(this.cameras, {super.key});
  @override
  State<TestCameraScreen> createState() => _TestCameraScreenState();
}

class _TestCameraScreenState extends State<TestCameraScreen> {
  TextEditingController searchController = TextEditingController();
  bool isTaken = false;
  late CameraController controller;
  XFile? img;
  ImagePicker picker = ImagePicker();
  File? pickedImage;
  Dio dio = Dio();
  var strVal = 'str';
  var shopName = 'Name';
  var shopID = 'id';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
    );
    await controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose of the camera controller
    super.dispose();
    print("This is dispose function message");
  }

  Future pickImage(BuildContext context, source) async {
    final ImagePicker imagePicker = ImagePicker();
    try{
      final img = await imagePicker.pickImage(source: source);
      if(img != null){
        setState((){
          this.img = img;
        });
        //Used to be here
        try{
          String filename = this.img!.path.split('/').last;
          FormData formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(this.img!.path, filename: filename, contentType: MediaType('image', 'jpeg')),
          });
          Response response = await dio.post(
            'https://mall-ml-model.lm.r.appspot.com/photos/',
            data: formData,
            options: Options(
              headers: {"Content-Type": "multipart/form-data"},
              method: 'POST',
              responseType: ResponseType.json,
            )
          );
          //print(response);
          //print("Hey");
          strVal = response.toString();
          //print(strVal);
          //strVal = insertAtIndex(strVal, '121', 12);
          int j = 11; // This id is the location of shop_id: {121}
          while(strVal[j] != ',') {
            j++;
          }
          shopID = strVal.substring(11, j);
          int i = strVal.length - 3; // This id is the place where the shopName ends, it searches until it reaches " symbol
          while (strVal[i] != '"') {
            i--;
          }
          shopName = strVal.substring(i, strVal.length - 1);
          print(shopID);
          shopName = shopsImages[shopID]!;
          print(shopName);
          //print("shopName is: $shopName");
          //print("shopID is: $shopID");
          setState(() {
            Navigator.pushNamed(context, AppRoutes.photoTwoScreen, arguments: {'data' : img.path, 'shopName' : shopName});
          });
        }catch(e){
          print(e);
        }
      }
    }on PlatformException catch(e){
      print("Failed to print image: $e");  
    }
  }

  //This is an additional function, needs to be deleted when server returns actual ids.
  String insertAtIndex(String originalString, String value, int index) {
    if (index < 0 || index > originalString.length) {
      throw RangeError.range(index, 0, originalString.length, 'index');
    }
    return originalString.substring(0, index) + value + originalString.substring(index);
  }

  Future<void> galleryImage() async {
    try {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null){
        setState(() {
          pickedImage = File(image.path);
          img = image;
        });
      }
      try{
          String filename = img!.path.split('/').last;
          FormData formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(img!.path, filename: filename, contentType: MediaType('image', 'jpeg')),
          });
          Response response = await dio.post(
            'https://mall-ml-model.lm.r.appspot.com/photos/',
            data: formData,
            options: Options(
              headers: {"Content-Type": "multipart/form-data"},
              method: 'POST',
              responseType: ResponseType.json,
            )
          );
          //print(response);
          //print("Hey");
          strVal = response.toString();
          //print(strVal);
          //strVal = insertAtIndex(strVal, '121', 12);
          int j = 11; // This id is the location of shop_id: {121}
          while(strVal[j] != ',') {
            j++;
          }
          shopID = strVal.substring(11, j);
          int i = strVal.length - 3; // This id is the place where the shopName ends, it searches until it reaches " symbol
          while (strVal[i] != '"') {
            i--;
          }
          shopName = strVal.substring(i, strVal.length - 1);
          print(shopID);
          shopName = shopsImages[shopID]!;
          print(shopName);
          //print("shopName is: $shopName");
          //print("shopID is: $shopID");
          setState(() {
            Navigator.pushNamed(context, AppRoutes.photoTwoScreen, arguments: {'data' : img!.path, 'shopName' : shopName});
          });
          }catch (e){
            print('Error picking image in $e');
          }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
     return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppBar(context),
          body: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                children: [
                  FalseCustomSearchView(
                      controller: searchController, hintText: "Search"),
                  SizedBox(height: 30.v),
                  Expanded(child: _buildButtons(context))
                ])),
          bottomNavigationBar: _buildNavbar(context))),
     );
         
  }

  /// Section Widget
  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomElevatedButton(
            height: 60.v,
            width: 300.h,
            text: "Pick from Gallery",
            onPressed: () {
              galleryImage();
              //onTapCANCEL(context);
            }),
        SizedBox(
          height: 30.v,
        ),
        CustomElevatedButton(
            height: 60.v,
            width: 300.h,
            text: "Open Camera",
            buttonStyle: CustomButtonStyles.fillGreenA,
            onPressed: () {
              pickImage(context, ImageSource.camera);
              //onTapPROCEED(context);
            })
      ]));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        centerTitle: true,
        title: AppbarTitle(text: "Where do you want to go?"));
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
Map<String, String> shopsImages = {
  '0': '33 pingvina',
  '1': '7Life',
  '2': 'ActualOptic',
  '3': 'Adika',
  '4': 'Adili',
  '5': 'AllOff',
  '6': 'AltynAlan',
  '7': 'AlyeParusa',
  '8': 'AngelinUs2',
  '9': 'AngelinUs1',
  '10': 'Anime Shop',
  '11': 'ArmaniExchange',
  '12': 'Askona',
  '13': 'Atelie',
  '14': 'Auz Tea',
  '15': 'Avanti',
  '16': 'Avrora1',
  '17': 'Avrora2',
  '18': 'BIGroup',
  '19': 'Bahandi',
  '20': 'Balausa',
  '21': 'Bambino',
  '22': 'Bao',
  '23': 'Basconi',
  '24': 'Baskin Robbins',
  '25': 'BearRichi',
  '26': 'Beautymania',
  '27': 'Beeline',
  '28': 'Bereke Bank',
  '29': 'Bershka',
  '30': 'Billion Co',
  '31': 'BlackStarBurger',
  '32': 'BobbyBrown',
  '33': 'BodyShop',
  '34': 'Bogachie',
  '35': 'Bro',
  '36': 'Bronoskins',
  '37': 'BurgerKing',
  '38': 'CalvinKleinJeans',
  '39': 'Calzedonia',
  '40': 'CasaMore',
  '41': 'Chapeau',
  '42': 'Chaplin Cinemas',
  '43': 'Chic',
  '44': 'Chullok',
  '45': 'City Men',
  '46': 'Climber',
  '47': 'Coffee Day',
  '48': 'CoffeeBoom',
  '49': 'Colins',
  '50': 'Columbia',
  '51': 'Cossmo',
  '52': 'Creperie de Paris',
  '53': 'Crocs',
  '54': 'DanielRizotto',
  '55': 'DeFacto',
  '56': 'Delish',
  '57': 'Diesel',
  '58': 'Dodo Pizza',
  '59': 'Doro',
  '60': 'DossoDossi',
  '61': 'Dyson',
  '62': 'Ecco',
  '63': 'Eco Glow',
  '64': 'Eco Home',
  '65': 'EcoClean',
  '66': 'Eliks',
  '67': 'EmilioGuido',
  '68': 'Epl',
  '69': 'Espresso Day',
  '70': 'Evrikum',
  '71': 'Fabiani',
  '72': 'Fagum',
  '73': 'Farsh',
  '74': 'Flo2',
  '75': 'Food Park',
  '76': 'Footie',
  '77': 'ForteBank',
  '78': 'Frato',
  '79': 'Freedom Mobile',
  '80': 'FrenchHouse',
  '81': 'Fruit Republic',
  '82': 'G-Shock',
  '83': 'Gaissina',
  '84': 'Galmart',
  '85': 'Gant',
  '86': 'Geox',
  '87': 'Glasman',
  '88': 'Glo',
  '89': 'Global Coffee',
  '90': 'Global Nomads',
  '91': 'GloriaJeans',
  '92': 'Guess',
  '93': 'Gulliver',
  '94': 'HM',
  '95': 'HalykBank',
  '96': 'HappyShoes',
  '97': 'Happylon',
  '98': 'Hardees',
  '99': 'HeyBaby',
  '100': 'Home Credit Bank',
  '101': 'Hugo',
  '102': 'Im',
  '103': 'Imperia Meha',
  '104': 'Injoy',
  '105': 'Inspire',
  '106': 'Instax',
  '107': 'Intertop',
  '108': 'Intimissimi',
  '109': 'Iqos',
  '110': 'Izbushka',
  '111': 'JackJones',
  '112': 'Jo Malone',
  '113': 'Jol',
  '114': 'Jolie',
  '115': 'Josiny',
  '116': 'Jusan',
  '117': 'KFC',
  '118': 'Kango',
  '119': 'Kanzler',
  '120': 'Kari',
  '121': 'Kaztour',
  '122': 'Keddo',
  '123': 'Kedma',
  '124': 'Kelzin',
  '125': 'Khan Mura',
  '126': 'Kids Art',
  '127': 'Kimex',
  '128': 'Kitikate',
  '129': 'KoreanHouse',
  '130': 'Kotofei',
  '131': 'Koton1',
  '132': 'Koton2',
  '133': 'L-Shoes',
  '134': 'LCWaikiki1',
  '135': 'LCWaikiki2',
  '136': 'LaVerna',
  '137': 'Lacoste',
  '138': 'LadyCollection',
  '139': 'Lazania',
  '140': 'Lee',
  '141': 'Leonardo',
  '142': 'LepimVarim',
  '143': 'Lero',
  '144': 'Levis',
  '145': 'Lichi',
  '146': 'Lining',
  '147': 'Loccitane',
  '148': 'LoveRepublic',
  '149': 'Lshoes',
  '150': 'Lucky Donuts',
  '151': 'Luxe',
  '152': 'Mac',
  '153': 'MadameCoco',
  '154': 'Majorica',
  '155': 'Mango',
  '156': 'MarcoPolo',
  '157': 'MarkFormelle',
  '158': 'MarroneRosso',
  '159': 'Marwin',
  '160': 'MassimoDutti',
  '161': 'McDonalds',
  '162': 'Mega Arena',
  '163': 'Mega Motors',
  '164': 'Mega Studio',
  '165': 'Mellis',
  '166': 'Mi',
  '167': 'MilaVitsa',
  '168': 'Mimioriki',
  '169': 'MiniCity',
  '170': 'Miniso',
  '171': 'Miuz',
  '172': 'Mixit',
  '173': 'Mobiland',
  '174': 'Monaco',
  '175': 'Mone',
  '176': 'Mothercare',
  '177': 'NewYorker',
  '178': 'Next',
  '179': 'NickolBeauty',
  '180': 'Nike',
  '181': 'Nomad',
  '182': 'NorthFace',
  '183': 'Nyx',
  '184': 'OceanBasket',
  '185': 'Oh My Gold',
  '186': 'Okaidi',
  '187': 'Orchestra',
  '188': 'Ostin1',
  '189': 'Ostin2',
  '190': 'Oysho',
  '191': 'Pablo',
  '192': 'Pandora',
  '193': 'Parfume de Vie',
  '194': 'Paul',
  '195': 'Penti',
  '196': 'Pharmacom',
  '197': 'Pinta',
  '198': 'Pivovaroff',
  '199': 'Plum Tea',
  '200': 'Podium',
  '201': 'PullBear',
  '202': 'Punto',
  '203': 'QazaqRepublic',
  '204': 'Reima',
  '205': 'Respect',
  '206': 'RitzyFasion',
  '207': 'Roberto Bravo',
  '208': 'Rumi',
  '209': 'SBF',
  '210': 'Sabville',
  '211': 'Saem',
  '212': 'Salomon',
  '213': 'Samsonite',
  '214': 'Sara Fashion',
  '215': 'Satty Zhuldyz',
  '216': 'Sberbank',
  '217': 'Shapo',
  '218': 'Shopogolik',
  '219': 'Silkway Beauty',
  '220': 'Skechers',
  '221': 'Sman',
  '222': 'SmartTel',
  '223': 'Solido',
  '224': 'SonyCentre',
  '225': 'Sportmaster',
  '226': 'Starbucks1',
  '227': 'Starbucks2',
  '228': 'Sterling Silver',
  '229': 'Stradivarius',
  '230': 'Superdry',
  '231': 'Swarovski',
  '232': 'Sweets',
  '233': 'Swisstime',
  '234': 'Taksim',
  '235': 'Technodom',
  '236': 'TerraNova',
  '237': 'The Body Shop',
  '238': 'Timberland',
  '239': 'Tissot',
  '240': 'Tobacco Shop',
  '241': 'TommyHilfiger',
  '242': 'Tucino',
  '243': 'USPoloAssn',
  '244': 'UlymyrzaHanym',
  '245': 'UnderArmour',
  '246': 'Untsia',
  '247': 'VR Zone',
  '248': 'Vicco',
  '249': 'Vitacci',
  '250': 'Viva',
  '251': 'WKey',
  '252': 'Walker',
  '253': 'Wanex',
  '254': 'Watch Avenue',
  '255': 'WhyNot',
  '256': 'Yakitoriya',
  '257': 'YamDam',
  '258': 'Yellow Corn',
  '259': 'YvesRocher',
  '260': 'Zara',
  '261': 'ZaraHome',
  '262': 'Zebra Coffee',
  '263': 'Zhekas',
  '264': 'ZhekasIce',
  '265': 'ZingalRiche',
  '266': 'Zolotoye Yabloko',
  '267': 'iSpace'
};