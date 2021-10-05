import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:greatplaces/datenBank/db_helper.dart';
import 'package:greatplaces/models/places.dart';
import 'package:sqflite/sqflite.dart';

class GreatPlaces with ChangeNotifier {
  List<Places> _items = [];

  List<Places> get items {
    return [..._items];
  }

  Places findById(String id){

    return items.firstWhere((places) => places.id ==id);
  }

  void addPlaces(
    String pickedTitle,
    File pickedImage,
    String pickedDescribtion
  ) {
    final newPlace = Places(
      id: DateTime.now().toString(),
      image: pickedImage,
      describtion: pickedDescribtion,
      title: pickedTitle,
    
    );
    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'describtion':newPlace.describtion,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Places(
            id: item['id'], 
            title: item['title'],
            describtion: item['describtion'],
            image: File(item['image']))).toList();
             
       
        notifyListeners();
  }
 
}
