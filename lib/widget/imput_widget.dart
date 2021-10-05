import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';

class ImageInput extends StatefulWidget {
final Function onSelectImage;

ImageInput(this.onSelectImage);



  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
Future <void>_takePicture() async{
  final imageFile= await ImagePicker.pickImage(
    source: ImageSource.gallery,
    maxHeight: 1200,
    maxWidth: 1200,
  );
  if (imageFile == null){return;
  
  }setState(() {
    _storedImage=imageFile;
  });

  final appDir= await syspaths.getApplicationDocumentsDirectory();
final fileName=path.basename(imageFile.path);

 final savedImage=await imageFile.copy('${appDir.path}/$fileName');
 widget.onSelectImage(savedImage);
}

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text("Kein Bild"),
              alignment:Alignment.center ,
          height: 100,
          width: 150,
          decoration:
              BoxDecoration(border: 
              Border.all(width: 1, color: Colors.green)),
        ),SizedBox(width: 10,),
         Expanded(child: Row(
           children:[ IconButton(onPressed: _takePicture,
             icon:Icon(Icons.camera) 
             ,),Text("Add Foto")
             ]
         ))
      ],
    );
  }
}
