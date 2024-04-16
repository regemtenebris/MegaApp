import 'package:cloud_firestore/cloud_firestore.dart';

class ShopData {
  final QueryDocumentSnapshot snapshot;
  bool isStarred;

  ShopData(this.snapshot, {this.isStarred = false});

 /*  Map<String, dynamic> toJson() {
    return {
      'id': snapshot['id'],
      'Picture' : snapshot['Picture'],
      'Category': snapshot['Category'],
      // Add other properties as needed
      'isStarred': isStarred,
    };
  }

  factory ShopData.fromJson(Map<String, dynamic> json, QueryDocumentSnapshot snapshot) {
    return ShopData(
      snapshot,
      isStarred: json['isStarred'] ?? false,
    );
  } */
}
