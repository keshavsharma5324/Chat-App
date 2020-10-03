import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'reg.dart';

class MyChat extends StatefulWidget {
  @override
  _MyChatState createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  var msgTextController = TextEditingController();
  var fs= FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;
  
  String chatmsg;
  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var signInUser = auth.currentUser.email;
    return Scaffold(
      appBar: AppBar(title: Text('chat'),
      actions: [CircleAvatar(backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/lwchatapp-d22e4.appspot.com/o/myimages%2Fmy123.jpg?alt=media&token=4527d8d4-df82-40f4-841b-6a051168d33e'),)],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>
            (builder: (context, snapshot){
              print('new data comes');

              var msg = snapshot.data.docs;
              //print(msg);
              //print(msg[0].data());
              List<Widget> y =[];
              for (var d in msg){
                //print(d.data()['sender']);
                var msgText = d.data()['text'];
                var msgSender = d.data()['sender'];
                var msgWidget = Text("$msgText : $msgSender");
                y.add(msgWidget);
              }
              print(y);

              return Container( 
                child: Column(children: y,)
              );
            },
            stream: fs.collection("chat").snapshots(),
            ),
            Row(
              children: [
                Container(
                  width : deviceWidth * 0.70,
                  child: TextField(
                    controller: msgTextController,
                    decoration: InputDecoration(hintText: 'Enter the msg..'),
                    onChanged: (value){
                    chatmsg = value;
                  },
                  ),
          
                ),
                Container(
                  width: deviceWidth * 0.20,
                  child: 
                FlatButton(child: Text('send'),
                onPressed: () async{
                  msgTextController.clear();
                 await fs.collection("chat").add({
                "text": chatmsg,
                "sender": signInUser, 
                 });
                 print(signInUser);
                },)
                )
              ],
            )
          ]
        ),
      ),
      
    );
  }
}