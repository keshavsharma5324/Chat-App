import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lwChatApp/screens/Splash.dart';
import 'package:lwChatApp/screens/myimage_cam.dart';

import 'screens/chat.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/reg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "mysplash",
    routes: {
      "home": (context) => Myhome(),
      "reg": (context) => MyReg(),
      "login": (context) => MyLogin(),
      "chat": (context) => MyChat(),
      "myimage": (context) => MyImage(),
      "mysplash": (context) => MySplash(),
    },
  ),
  );
}