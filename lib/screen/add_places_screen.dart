import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:greatplaces/provider/greatplaces.dart';
import 'package:greatplaces/widget/imput_widget.dart';


class AddPlacesScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlacesScreenState createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends State<AddPlacesScreen> {
final _titleController=TextEditingController();
final _describtionController=TextEditingController();


File _pickedImage;
void _selectImage(File pickedImage){
  _pickedImage = pickedImage;
}

void _savePlace(){
  if(_titleController.text.isEmpty|| _describtionController.text.isEmpty|| _pickedImage==null){
    return;
  }
Provider.of<GreatPlaces>(context, listen: false).addPlaces(_titleController.text, _pickedImage, _describtionController.text);
Navigator.of(context).pop();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Deine Geschichte")),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
           
                  ImageInput(_selectImage),
                  SizedBox(height: 10,),
                         TextField(controller: _describtionController,cursorColor: Colors.white,
                    decoration: InputDecoration(labelText: "Titel"),style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                         TextField(controller: _titleController,cursorColor: Colors.white,
                    decoration: InputDecoration(labelText: "Titel"),style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          )),
          TextButton(
            onPressed: _savePlace,
            child: Text("add places"),
          ),
        ],
      ),
    );
  }
}
