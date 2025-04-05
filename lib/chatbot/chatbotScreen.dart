import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _messages = [];

  void _handleSubmit() {
    final input = _nameController.text.trim();
    if (input.isEmpty) return;
    setState(() {
      _messages.add("You: $input");
      _messages.add("Bot: $input");
    });
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade100, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.android, size: 30, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildChatBubble(_messages[index]);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildInputField()),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blueAccent),
                        onPressed: _handleSubmit,
                      ),
                    ],
                  ),
                  _buildAlternativeOption(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.lato(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: "Type a message",
      ),
      onSubmitted: (_) => _handleSubmit(),
    );
  }

  Widget _buildAlternativeOption() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(
          "I'd prefer not to say",
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
