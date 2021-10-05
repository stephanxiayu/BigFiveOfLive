

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:greatplaces/provider/greatplaces.dart';
import 'package:greatplaces/screen/add_places_screen.dart';
import 'package:greatplaces/screen/place_detail_screen.dart';
import 'package:greatplaces/screen/placeslist_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),child: MaterialApp(
        debugShowCheckedModeBanner: false,
     
      theme: ThemeData.dark(
     
        
      ),
    home: PlacesListScreen(),
    routes: {AddPlacesScreen.routeName:(ctx)=>AddPlacesScreen(),
    
    Details.routeName:(context)=>Details(),
    
    },
     ) );
  }
}




 