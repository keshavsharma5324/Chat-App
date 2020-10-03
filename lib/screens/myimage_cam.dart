import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
class MyImage extends StatefulWidget   {
  @override
  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  var imageurl; 
  var furl;
  File imagefilepath;
  clickphoto() async{
    var picker = ImagePicker();
    var photo = await picker.getImage(source: ImageSource.camera
    ,maxWidth:200,
    maxHeight: 200); 
     
    print('photo clicked');
    setState(() {
      imagefilepath = File(photo.path);
    });
    print(imagefilepath);
    var fbstorage = FirebaseStorage.instance.ref().child("myimages").child("my3.jpg");
    print(fbstorage);
    fbstorage.putFile(imagefilepath);
    imageurl = await fbstorage.getDownloadURL();
    print(imageurl);
    setState(()  {
      furl = imageurl;
    }); 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: 
          clickphoto,
        ),
      appBar: AppBar(
        title: Text('Image'),
        actions: <Widget>[CircleAvatar(backgroundImage: imageurl == null ? NetworkImage('https://firebasestorage.googleapis.com/v0/b/lwchatapp-d22e4.appspot.com/o/myimages%2Fmy3.jpg?alt=media&token=8b68b0f2-867d-45db-851c-d150ba6d857e'): NetworkImage(imageurl),)
        ],
        ),
        body: Container(
          width: 200,
          height: 200,
          color: Colors.amberAccent,
          child: imagefilepath == null?
          Text('sel ur image')
          :Image.file(imagefilepath),
       ),
    );
  }
}