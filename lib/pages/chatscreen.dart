import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:veritasapp/Widgets/bottomnavigation.dart';
import 'package:veritasapp/messages.dart';

class chatsection extends StatefulWidget {
  final String receivertype;

  const chatsection({super.key, required this.receivertype});

  @override
  State<chatsection> createState() => _chatsectionState();
}

class _chatsectionState extends State<chatsection> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController _message = TextEditingController();

  String getChatRoomId() {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    List<String> ids = [currentUserId, widget.receivertype];
    ids.sort();
    return ids.join("_");
  }

  void getAiResponse(
      String message, String currentUserId, String currentUserEmail) async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyDDMwcUsuQwx3hxkcbdmu2TUqQNvWCG-mI";
    final header = {"Content-Type": "application/json"};
    final data = {
      "contents": [
        {
          "parts": [
            {"text": message}
          ]
        }
      ]
    };
    final Timestamp timestamp = Timestamp.now();

    await http
        .post(Uri.parse(url), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body)['candidates'][0]['content']
            ['parts'][0]['text'];
        Message newMessage = Message(
            senderId: widget.receivertype,
            senderEmail: "NaN",
            recieverId: currentUserId,
            recieverEmail: currentUserEmail,
            message: response,
            timestamp: timestamp);
        _db
            .collection("chat_room")
            .doc(getChatRoomId())
            .collection("message")
            .add(newMessage.toMap());
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationDabba(
        index: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
          // print("Selected Index: $index");
        },
        backgroundColor: Color.fromRGBO(132, 189, 255, 1),
        buttonColor: Colors.black,
        icons: [Icons.home, Icons.file_copy, Icons.payment],
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[100],
        title: Padding(
          padding: EdgeInsets.only(right: 50),
          child: Center(
            child: const Text(
              "Chat Bot",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _db
                    .collection("chat_room")
                    .doc(getChatRoomId())
                    .collection("message")
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapShot) {
                  List<Widget> messagesent = [];
                  if (snapShot.hasData) {
                    final messages = snapShot.data?.docs.reversed.toList();
                    for (var i in messages!) {
                      bool isCurrentUser =
                          i["senderId"] == _firebaseAuth.currentUser!.uid;
                      messagesent.add(
                        Align(
                          alignment: isCurrentUser
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Colors.blueAccent[100]
                                    : Color.fromRGBO(132, 189, 255, 1),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: isCurrentUser
                                      ? Colors.blueAccent[200]
                                      : Colors.black,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: MarkdownBody(
                                  data: i["message"], // Markdown parsing
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white), // Customize text
                                    strong: TextStyle(
                                        fontWeight:
                                            FontWeight.bold), // Bold support
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: messagesent,
                      ),
                    ),
                  );
                }),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent[100],
                          borderRadius: BorderRadius.all(Radius.circular(25.7)),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null, // Allow infinite lines
                          controller: _message,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.emoji_emotions_outlined),
                            hintText: 'Message',
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        final String currentUserId =
                            _firebaseAuth.currentUser!.uid;
                        final String currentUserEmail =
                            _firebaseAuth.currentUser!.email.toString();
                        final Timestamp timestamp = Timestamp.now();

                        if (_message.text.trim().isNotEmpty) {
                          Message newMessage = Message(
                              senderId: currentUserId,
                              senderEmail: currentUserEmail,
                              recieverId: widget.receivertype,
                              recieverEmail: "NaN",
                              message: _message.text.trim(),
                              timestamp: timestamp);
                          _db
                              .collection("chat_room")
                              .doc(getChatRoomId())
                              .collection("message")
                              .add(newMessage.toMap());

                          if (widget.receivertype == "chatbot") {
                            getAiResponse(_message.text.trim(), currentUserId,
                                currentUserEmail);
                          }
                          _message.clear();
                        }
                      },
                      backgroundColor: Colors.blueAccent[100],
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.send,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
