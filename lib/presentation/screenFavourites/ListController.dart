import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mally/presentation/category_screen/shopData.dart';

class ListController extends GetxController {
  var itemList = <ShopData>[].obs;
}