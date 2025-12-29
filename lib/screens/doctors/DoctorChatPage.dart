import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorChatPage extends StatefulWidget {
  final String doctorName;

  DoctorChatPage({super.key, required this.doctorName});

  @override
  State<DoctorChatPage> createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {
  List<Map<String, dynamic>> messages = [
    {
      "fromMe": false,
      "text": "Hello, how can I help you today?",
    },
    {
      "fromMe": true,
      "text": "I want to lose weight and improve my diet.",
    },
  ];

  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "fromMe": true,
        "text": messageController.text.trim(),
      });
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.doctorName),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale(Locale("ar"));
              } else {
                context.setLocale(Locale("en"));
              }
            },
            icon: Icon(Icons.language),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final fromMe = msg["fromMe"] as bool;
                return Align(
                  alignment:
                  fromMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: fromMe
                          ? Colors.green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"] as String,
                      style: TextStyle(
                        color: fromMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...".tr(),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

