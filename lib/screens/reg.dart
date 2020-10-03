import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class MyReg extends StatefulWidget {
  @override
  MyRegState createState() => MyRegState();
}

class MyRegState extends State<MyReg> {
  var auth = FirebaseAuth.instance;
  var fs = FirebaseFirestore.instance;
  String email;
  String password;
  var imageurl; 
  File imagefilepath;
  var furl;
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
    var fbstorage = FirebaseStorage.instance.ref().child("myimages").child("my123.jpg");
    print(fbstorage);   
    fbstorage.putFile(imagefilepath);
    imageurl = await fbstorage.getDownloadURL();
    print(imageurl);
    await fs.collection("imgurl").add({
      "profileurl": imageurl == null ? "waiting" : imageurl,
    });
    setState(()  {
      furl = imageurl;
    }); 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('registration'),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            CircleAvatar(
              radius: 60,
              backgroundImage: furl != null ? NetworkImage(furl): null,
            ),
            RaisedButton(child: Text('click'),onPressed: (){clickphoto();},),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) { email = value;},
            decoration: InputDecoration(
            hintText: "Enter Email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
            ),
            ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) { password=value; },
            decoration: InputDecoration(
            hintText: "Enter your password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
            ),
            ),
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(10),
              elevation: 10,
              child: MaterialButton(
                minWidth: 200,
                height: 40,
                child: Text('submit'),
                onPressed: () async{
                  try{
                  var user = await auth.createUserWithEmailAndPassword
                  (email: email, password: password);
                  print(email);
                  print(password);
                  print(user);
                  if(user.additionalUserInfo.isNewUser==true){
                    Navigator.pushNamed(context, "chat");
                  }
                  }
                  catch(e){
                    print(e);
                  }
                },
                )

            ),
          ]),
        ),
      ),      
    );
  }
}