// ignore_for_file: library_private_types_in_public_api, camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class parentChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String trainerName;

  const parentChatScreen(
      {super.key,
      required this.senderId,
      required this.receiverId,
      required this.trainerName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<parentChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var profPic = "";
  getTrainerName() async {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("trainers");
    await userRef.get().then((value) {
      for (var element in value.docs) {
        if (element['uid'].toString() == widget.senderId) {
          setState(() {
            profPic = element['profilePic'].toString();
          });
          break;
        }
      }
    });
  }

  @override
  void initState() {
    getTrainerName();
    super.initState();
  }

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
                /*const Text(
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    ": التحدث مع"),*/
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 4,
                      color: const Color.fromARGB(255, 33, 37, 243),
                    ),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 10),
                      ),
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(profPic),
                    ),
                  ),
                ),
                Text(
                  "${widget.trainerName} ",
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w900),
                ),
              ],
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/HomePage/WhatsAppImage.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
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
                        mainAxisAlignment: !docs[index]['isSent']
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!docs[index]['isSent'])
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(158, 17, 155, 22),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                docs[index]['message'],
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ),
                          if (docs[index]['isSent'])
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        style: const TextStyle(fontSize: 20.0),
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالة',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      String message = _textEditingController.text.trim();

                      if (message.isNotEmpty) {
                        setState(() {
                          FirebaseFirestore.instance.collection('chats').add({
                            'senderId': widget.senderId,
                            'receiverId': widget.receiverId,
                            'message': message,
                            'timestamp': FieldValue.serverTimestamp(),
                            'isSent': false,
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
      ),
    );
  }
}
//hummm