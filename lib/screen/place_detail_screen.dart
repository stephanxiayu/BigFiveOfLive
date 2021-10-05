

import 'package:flutter/material.dart';
import 'package:greatplaces/datenBank/db_helper.dart';
import 'package:greatplaces/provider/greatplaces.dart';
import 'package:provider/provider.dart';


class Details extends StatelessWidget {
  static const routeName ='/details';


  @override
  Widget build(BuildContext context) {

    final id= ModalRoute.of(context).settings.arguments;
    final selectedPlace=Provider.of<GreatPlaces>(context ).findById(id);
    return Scaffold(appBar: AppBar(title:Text(selectedPlace.title) ,),
      body: Column(
       children: [

         Container(height: 300, width: double.infinity,child: Image.file(selectedPlace.image, fit: BoxFit.fill,),
         
         ), 
         Text(selectedPlace.title)
         
       ],
      ),
    );
  }
}