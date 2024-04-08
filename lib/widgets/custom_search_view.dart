import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mally/core/app_export.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';



class CustomSearchView extends StatelessWidget {
  CustomSearchView({
    super.key,
    this.alignment,
    this.width,
    this.controller,
    this.focusNode,
    this.autofocus = true,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
    //this.onTap
  });
  
  final Alignment? alignment;

  final double? width;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;

  //final VoidCallback? onTap;

  var strVal = 'str';
  var shopName = 'Name';
  var shopID = 'id';

  Future<String> voiceRecord() async {
    FlutterSoundRecorder flutterSoundRecorder = FlutterSoundRecorder();
    //String path = "C:/Users/77755/Desktop/voiceFromFlutter/Sound.wav";
    String fileName = 'Sound.wav'; // File name
    Directory appDocDirectory;
    String path = '';

    try {
      appDocDirectory = await getApplicationDocumentsDirectory();
      path = appDocDirectory.path + '/' + fileName; // Full file path

      print('starting...');
      await flutterSoundRecorder.openRecorder();
      await flutterSoundRecorder.startRecorder(
        toFile: path,
        //codec: Codec.pcm16WAV,
      );
      print('Recording...');
      // Add a delay or use a button to stop recording
      await Future.delayed(const Duration(seconds: 3));

      await flutterSoundRecorder.stopRecorder();
    } catch (e) {
      print('Error recording voice: $e');
    } finally {
      // Dispose of the recorder to release resources
      await flutterSoundRecorder.closeRecorder();
    }

    print('Recording stopped');
    print(path);
    String text = await sendAudioToServer(path);
    print("Text From: $text");
    return text;
    // Now you can use the recorded file path (variable 'path') to send it to the server.
  }

  Future<String> sendAudioToServer(String audioFilePath) async {
    String text = 'Search1';
    String filename = basename(audioFilePath);
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        audioFilePath,
        filename: filename,
        contentType: MediaType('audio', 'wav'), // Set content type to audio/wav
      ),
    });

    try {
      Response response = await Dio().post(
        'https://mall-ml-model.lm.r.appspot.com/audios/',
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
          method: 'POST',
          responseType: ResponseType.json,
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      text = response.toString();
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
      shopName = shopsAudios[shopID]!;
      //print(shopName);
      
      //print("shopName is: $shopName");
      //print("shopID is: $shopID");
      text = shopName;
      print("Text is: $text");
    } catch (e) {
      print('Error sending audio: $e');
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: searchViewWidget,
          )
        : searchViewWidget;
  }

  Widget get searchViewWidget => SizedBox(
        width: width ?? double.maxFinite,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode ?? FocusNode(),
          autofocus: autofocus!,
          style: textStyle ?? CustomTextStyles.bodyLargeInterPrimary,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
          onChanged: (String value) {
            onChanged!.call(value);
          },
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.bodyLargeInterPrimary,
        prefixIcon: prefix ??
            Container(
              margin: EdgeInsets.fromLTRB(12.h, 11.v, 4.h, 11.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgSearch,
                height: 24.adaptSize,
                width: 24.adaptSize,
              ),
            ),
        prefixIconConstraints: prefixConstraints ??
            BoxConstraints(
              maxHeight: 46.v,
            ),
        suffixIcon: suffix ??
            Container(
              margin: EdgeInsets.fromLTRB(30.h, 11.v, 12.h, 11.v),
              child: GestureDetector(
                onTap: () async {
                  String transcript = await voiceRecord();
                  controller?.text = transcript;
                },
                child: CustomImageView(
                  imagePath: ImageConstant.imgIconmic,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                ),
              ),
            ),
        suffixIconConstraints: suffixConstraints ??
            BoxConstraints(
              maxHeight: 46.v,
            ),
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 13.v),
        fillColor: fillColor ?? appTheme.whiteA700,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1,
              ),
            ),
      );
}

Map<String, String> shopsAudios = {
  '0': '33 pingvina',
  '1': '7Life',
  '2': 'ActualOptic',
  '3': 'Adika',
  '4': 'Adili',
  '5': 'AllOff',
  '6': 'AltynAlan',
  '7': 'AlyeParusa',
  '8': 'AngelinUs1',
  '9': 'Anime Shop',
  '10': 'ArmaniExchange',
  '11': 'Askona',
  '12': 'Atelie',
  '13': 'Auz Tea',
  '14': 'Avanti',
  '15': 'Avrora1',
  '16': 'BIGroup',
  '17': 'Bahandi',
  '18': 'Balausa',
  '19': 'Bambino',
  '20': 'Bao',
  '21': 'Basconi',
  '22': 'Baskin Robbins',
  '23': 'BearRichi',
  '24': 'Beautymania',
  '25': 'Beeline',
  '26': 'Bereke Bank',
  '27': 'Bershka',
  '28': 'Billion Co',
  '29': 'BlackStarBurger',
  '30': 'BobbyBrown',
  '31': 'BodyShop',
  '32': 'Bogachie',
  '33': 'Bro',
  '34': 'Bronoskins',
  '35': 'BurgerKing',
  '36': 'CalvinKleinJeans',
  '37': 'Calzedonia',
  '38': 'CasaMore',
  '39': 'Chapeau',
  '40': 'Chaplin Cinemas',
  '41': 'Chic',
  '42': 'Chullok',
  '43': 'City Men',
  '44': 'Climber',
  '45': 'Coffee Day',
  '46': 'CoffeeBoom',
  '47': 'Colins',
  '48': 'Columbia',
  '49': 'Cossmo',
  '50': 'Creperie de Paris',
  '51': 'Crocs',
  '52': 'DanielRizotto',
  '53': 'DeFacto',
  '54': 'Delish',
  '55': 'Diesel',
  '56': 'Dodo Pizza',
  '57': 'Doro',
  '58': 'DossoDossi',
  '59': 'Dyson',
  '60': 'Ecco',
  '61': 'Eco Glow',
  '62': 'Eco Home',
  '63': 'EcoClean',
  '64': 'Eliks',
  '65': 'EmilioGuido',
  '66': 'Epl',
  '67': 'Espresso Day',
  '68': 'Evrikum',
  '69': 'Fabiani',
  '70': 'Fagum',
  '71': 'Farsh',
  '72': 'Flo2',
  '73': 'Food Park',
  '74': 'Footie',
  '75': 'ForteBank',
  '76': 'Frato',
  '77': 'Freedom Mobile',
  '78': 'FrenchHouse',
  '79': 'Fruit Republic',
  '80': 'G-Shock',
  '81': 'Gaissina',
  '82': 'Galmart',
  '83': 'Gant',
  '84': 'Geox',
  '85': 'Glasman',
  '86': 'Glo',
  '87': 'Global Coffee',
  '88': 'Global Nomads',
  '89': 'GloriaJeans',
  '90': 'Guess',
  '91': 'Gulliver',
  '92': 'HM',
  '93': 'HalykBank',
  '94': 'HappyShoes',
  '95': 'Happylon',
  '96': 'Hardees',
  '97': 'HeyBaby',
  '98': 'Home Credit Bank',
  '99': 'Hugo',
  '100': 'Im',
  '101': 'Imperia Meha',
  '102': 'Injoy',
  '103': 'Inspire',
  '104': 'Instax',
  '105': 'Intertop',
  '106': 'Intimissimi',
  '107': 'Iqos',
  '108': 'Izbushka',
  '109': 'JackJones',
  '110': 'Jo Malone',
  '111': 'Jol',
  '112': 'Jolie',
  '113': 'Josiny',
  '114': 'Jusan',
  '115': 'KFC',
  '116': 'Kango',
  '117': 'Kanzler',
  '118': 'Kari',
  '119': 'Kaztour',
  '120': 'Keddo',
  '121': 'Kedma',
  '122': 'Kelzin',
  '123': 'Khan Mura',
  '124': 'Kids Art',
  '125': 'Kimex',
  '126': 'Kitikate',
  '127': 'KoreanHouse',
  '128': 'Kotofei',
  '129': 'Koton1',
  '130': 'L-Shoes',
  '131': 'LCWaikiki1',
  '132': 'LaVerna',
  '133': 'Lacoste',
  '134': 'LadyCollection',
  '135': 'Lazania',
  '136': 'Lee',
  '137': 'Leonardo',
  '138': 'LepimVarim',
  '139': 'Lero',
  '140': 'Levis',
  '141': 'Lichi',
  '142': 'Lining',
  '143': 'Loccitane',
  '144': 'LoveRepublic',
  '145': 'Lshoes',
  '146': 'Lucky Donuts',
  '147': 'Luxe',
  '148': 'Mac',
  '149': 'MadameCoco',
  '150': 'Majorica',
  '151': 'Mango',
  '152': 'MarcoPolo',
  '153': 'MarkFormelle',
  '154': 'MarroneRosso',
  '155': 'Marwin',
  '156': 'MassimoDutti',
  '157': 'McDonalds',
  '158': 'Mega Arena',
  '159': 'Mega Motors',
  '160': 'Mega Studio',
  '161': 'Mellis',
  '162': 'Mi',
  '163': 'MilaVitsa',
  '164': 'Mimioriki',
  '165': 'MiniCity',
  '166': 'Miniso',
  '167': 'Miuz',
  '168': 'Mixit',
  '169': 'Mobiland',
  '170': 'Monaco',
  '171': 'Mone',
  '172': 'Mothercare',
  '173': 'NewYorker',
  '174': 'Next',
  '175': 'NickolBeauty',
  '176': 'Nike',
  '177': 'Nomad',
  '178': 'NorthFace',
  '179': 'Nyx',
  '180': 'OceanBasket',
  '181': 'Oh My Gold',
  '182': 'Okaidi',
  '183': 'Orchestra',
  '184': 'Ostin1',
  '185': 'Oysho',
  '186': 'Pablo',
  '187': 'Pandora',
  '188': 'Parfume de Vie',
  '189': 'Paul',
  '190': 'Penti',
  '191': 'Pharmacom',
  '192': 'Pinta',
  '193': 'Pivovaroff',
  '194': 'Plum Tea',
  '195': 'Podium',
  '196': 'PullBear',
  '197': 'Punto',
  '198': 'QazaqRepublic',
  '199': 'Reima',
  '200': 'Respect',
  '201': 'RitzyFasion',
  '202': 'Roberto Bravo',
  '203': 'Rumi',
  '204': 'SBF',
  '205': 'Sabville',
  '206': 'Saem',
  '207': 'Salomon',
  '208': 'Samsonite',
  '209': 'Sara Fashion',
  '210': 'Satty Zhuldyz',
  '211': 'Sberbank',
  '212': 'Shapo',
  '213': 'Shopogolik',
  '214': 'Silkway Beauty',
  '215': 'Skechers',
  '216': 'Sman',
  '217': 'SmartTel',
  '218': 'Solido',
  '219': 'SonyCentre',
  '220': 'Sportmaster',
  '221': 'Starbucks1',
  '222': 'Sterling Silver',
  '223': 'Stradivarius',
  '224': 'Superdry',
  '225': 'Swarovski',
  '226': 'Sweets',
  '227': 'Swisstime',
  '228': 'Taksim',
  '229': 'Technodom',
  '230': 'TerraNova',
  '231': 'The Body Shop',
  '232': 'Timberland',
  '233': 'Tissot',
  '234': 'Tobacco Shop',
  '235': 'TommyHilfiger',
  '236': 'Tucino',
  '237': 'USPoloAssn',
  '238': 'UlymyrzaHanym',
  '239': 'UnderArmour',
  '240': 'Untsia',
  '241': 'VR Zone',
  '242': 'Vicco',
  '243': 'Vitacci',
  '244': 'Viva',
  '245': 'WKey',
  '246': 'Walker',
  '247': 'Wanex',
  '248': 'Watch Avenue',
  '249': 'WhyNot',
  '250': 'Yakitoriya',
  '251': 'YamDam',
  '252': 'Yellow Corn',
  '253': 'YvesRocher',
  '254': 'Zara',
  '255': 'ZaraHome',
  '256': 'Zebra Coffee',
  '257': 'Zhekas',
  '258': 'ZhekasIce',
  '259': 'ZingalRiche',
  '260': 'Zolotoye Yabloko',
  '261': 'iSpace'
};