// ignore_for_file: library_private_types_in_public_api, camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class trainerChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String parentName;

  const trainerChatScreen(
      {super.key,
      required this.senderId,
      required this.receiverId,
      required this.parentName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<trainerChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("widget.receiverId");
      print(widget.receiverId);
    }
    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerRight,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                const Text(
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    ": التحدث مع"),
                Text(
                  "${widget.parentName} ",
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w900),
                ),
              ],
            )),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('senderId', isEqualTo: widget.senderId)
                  .where('receiverId', isEqualTo: widget.receiverId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: docs[index]['isSent']
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (docs[index]['isSent'])
                          Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Text(
                              docs[index]['message'],
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ),
                        if (!docs[index]['isSent'])
                          Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Text(
                              docs[index]['message'],
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String message = _textEditingController.text.trim();

                    if (message.isNotEmpty) {
                      setState(() {
                        FirebaseFirestore.instance.collection('chats').add({
                          'senderId': widget.senderId,
                          'receiverId': widget.receiverId,
                          'message': message,
                          'timestamp': DateTime.now(),
                          'isSent': true,
                        });
                      });

                      _textEditingController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
