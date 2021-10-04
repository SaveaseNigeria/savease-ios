import 'package:firebase_database/firebase_database.dart';

class PromotionModel {
  String desc;
  String imageUrl;

  PromotionModel(this.imageUrl,this.desc);

  PromotionModel.fromSnapshot(DataSnapshot snapshot)
      :
        desc = snapshot.value["desc"],
        imageUrl = snapshot.value["imageUrl"];


}