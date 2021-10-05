import 'package:flutter/foundation.dart';
import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocation(
      {@required this.latitude, @required this.longitude, this.address});
}

class Places {
  final String id;
  final String title;
  final String describtion;
  final PlaceLocation location;
  final File image;
  Places(
      {@required this.id,
      @required this.image,
      @required this.describtion,
      @required this.location,
      @required this.title});
}
