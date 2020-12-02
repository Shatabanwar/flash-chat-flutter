//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _FireStore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {

  static const String id = 'chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  User loggedInUser;        //FireBase User
  String text;


  @override
  void initState() {

    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {

    try{

      final user =   _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        print(loggedInUser.email);

      }


    } catch(e){
      print(e);
    }


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        text = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _FireStore.collection('messages').add({
                        'text' : text,
                        'sender' : loggedInUser.email,
                      });

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _FireStore.collection('messages').snapshots(),
      builder: (context, snapshot){

        if (!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.docs;
        List<MessageBubble> messageBubble = [];
        for(var message in messages){
          final messageText = message.get('text');
          final messageSender = message.get('sender');

          final messageBubbles = MessageBubble(sender: messageSender, text: messageText);
          messageBubble.add(messageBubbles);

        }

        return Expanded(
          child: ListView(
            children: messageBubble,
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
          ),
        );
      },


    );
  }
}


class MessageBubble extends StatelessWidget {

  MessageBubble({this.sender,this.text});

  final String sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(sender,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12.0
          ),
          ),
          Material(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: Text(text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0
                    ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
