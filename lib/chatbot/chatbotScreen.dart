import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart' as mime;

// Replace with your actual Gemini API key
const String apiKey = 'AIzaSyB9QHXGKkyWAeE5fw64wYXCuzfv2pwOr3E';
const String modelName = "gemini-2.5-pro-exp-03-25"; // Changed model name

class Part {
  final String? text;
  final InlineData? inlineData;

  Part({this.text, this.inlineData});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (text != null) {
      data['text'] = text;
    }
    if (inlineData != null) {
      data['inlineData'] = inlineData!.toJson();
    }
    return data;
  }
}

class InlineData {
  final String mimeType;
  final String data;

  InlineData({required this.mimeType, required this.data});

  Map<String, dynamic> toJson() {
    return {'mimeType': mimeType, 'data': data};
  }
}

class Content {
  final String role;
  final List<Part> parts;

  Content({required this.role, required this.parts});

  Map<String, dynamic> toJson() {
    return {'role': role, 'parts': parts.map((part) => part.toJson()).toList()};
  }

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      role: json['role'] as String,
      parts:
          (json['parts'] as List<dynamic>)
              .map(
                (e) => Part(
                  text: (e as Map<String, dynamic>)['text'] as String?,
                  inlineData:
                      (e as Map<String, dynamic>)['inlineData'] == null
                          ? null
                          : InlineData(
                            mimeType:
                                (e['inlineData']
                                        as Map<String, dynamic>)['mimeType']
                                    as String,
                            data:
                                (e['inlineData']
                                        as Map<String, dynamic>)['data']
                                    as String,
                          ),
                ),
              )
              .toList(),
    );
  }
}

class GenerationConfig {
  final double? temperature;
  final double? topP;
  final int? topK;
  final int? maxOutputTokens;
  final List<String>? responseModalities;
  final String? responseMimeType;

  GenerationConfig({
    this.temperature,
    this.topP,
    this.topK,
    this.maxOutputTokens,
    this.responseModalities,
    this.responseMimeType,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (temperature != null) {
      data['temperature'] = temperature;
    }
    if (topP != null) {
      data['topP'] = topP;
    }
    if (topK != null) {
      data['topK'] = topK;
    }
    if (maxOutputTokens != null) {
      data['maxOutputTokens'] = maxOutputTokens;
    }
    if (responseModalities != null) {
      data['responseModalities'] = responseModalities;
    }
    if (responseMimeType != null) {
      data['responseMimeType'] = responseMimeType;
    }
    return data;
  }
}

class ChatSessionRequest {
  final GenerationConfig? generationConfig;
  final List<Content> contents; // Changed 'history' to 'contents'

  ChatSessionRequest({this.generationConfig, required this.contents});

  Map<String, dynamic> toJson() {
    return {
      'generationConfig': generationConfig?.toJson(),
      'contents':
          contents
              .map((content) => content.toJson())
              .toList(), // Changed 'history' to 'contents'
    };
  }
}

class ChatSessionResponse {
  final List<Candidate>? candidates;

  ChatSessionResponse({this.candidates});

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) {
    return ChatSessionResponse(
      candidates:
          (json['candidates'] as List<dynamic>?)
              ?.map((e) => Candidate.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class Candidate {
  final Content content;

  Candidate({required this.content});

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _messages = [];
  final List<Content> _history = [
    Content(
      role: "user",
      parts: [
        Part(
          text:
              "You are an AI-powered professional specializing in nutrition and malnutrition management. Your role is to provide accurate, evidence-based guidance on identifying, preventing, and addressing malnutrition across various demographics. Your responses should be well-structured, professional, and tailored to the user's needs. You should incorporate the latest nutritional research and guidelines while maintaining an empathetic and supportive tone. Avoid giving medical diagnoses but provide recommendations based on established dietary principles._\n\n **Capabilities:**\n- Analyze symptoms and risks of malnutrition\n- Provide dietary recommendations tailored to age, health status, and nutritional needs\n- Suggest ways to prevent malnutrition through balanced nutrition and lifestyle changes\n- Offer guidance on recovery strategies for malnourished individuals\n- Provide credible sources for further reading or consultation with healthcare professionals\n\n **Guidelines for Responses:**\n- Maintain professionalism and ensure accuracy using reputable nutrition sources (e.g., WHO, FDA, academic research).\n- Be clear, concise, and user-friendly in explaining complex nutritional concepts.\n- Offer general recommendations while encouraging users to seek medical professionals for detailed assessments.\n- Adapt responses to different demographics, including children, elderly individuals, and those with specific health conditions.",
        ),
      ],
    ),
    Content(
      role: "model",
      parts: [
        Part(
          text:
              "Okay, I understand. I am ready to act as your AI-powered professional specializing in nutrition and malnutrition management.\n\nMy purpose is to provide accurate, evidence-based guidance on identifying potential signs and risk factors, preventing, and addressing malnutrition across diverse populations. I will base my responses on established dietary principles, current nutritional research, and guidelines from reputable organizations like the World Health Organization (WHO) and relevant national health bodies.\n\n**My capabilities include:**\n\n1.  **Identifying Potential Malnutrition:** Helping you recognize potential signs, symptoms, and risk factors associated with various forms of malnutrition (undernutrition, micronutrient deficiencies, overweight/obesity).\n2.  **Tailored Nutritional Guidance:** Providing general dietary recommendations adjusted for different life stages (infancy, childhood, adolescence, adulthood, elderly), specific health statuses (e.g., during illness recovery, chronic conditions – *within the scope of general advice*), and varying nutritional needs.\n3.  **Prevention Strategies:** Suggesting practical ways to promote balanced nutrition and healthy lifestyle choices to prevent the onset of malnutrition.\n4.  **Nutritional Support Guidance:** Offering general advice on dietary strategies that can support recovery in individuals identified as malnourished by healthcare professionals.\n5.  **Resource Provision:** Directing you towards credible sources (like WHO, national health guidelines, peer-reviewed journals) for further information and strongly encouraging consultation with registered dietitians, nutritionists, or medical doctors for personalized assessment and treatment plans.\n\n**My Approach:**\n\n* **Professional & Evidence-Based:** I will rely on scientific consensus and established guidelines.\n* **Clear & Understandable:** I will break down complex nutritional information into easy-to-understand language.\n* **Empathetic & Supportive:** I recognize that discussing nutrition and health can be sensitive, and I will maintain a supportive tone.\n* **Cautious & Responsible:** I will **not** provide medical diagnoses or specific treatment plans. My guidance is for informational purposes and should complement, not replace, advice from qualified healthcare professionals.\n\nI am prepared to assist you. Please let me know how I can help you today. For example, you could ask about:\n\n* Signs of potential nutrient deficiencies in children.\n* General dietary tips for older adults to maintain muscle mass.\n* Ways to improve dietary diversity on a budget.\n* Nutritional considerations for recovery after surgery (general advice).\n\nHow can I assist you with nutrition and malnutrition management?",
        ),
      ],
    ),
  ];

  Future<ChatSessionResponse> _sendMessageToChatbot(String message) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey',
    );

    final headers = {'Content-Type': 'application/json'};

    // Create the list of content including history and the current message
    List<Content> allContents = [
      ..._history,
      Content(role: "user", parts: [Part(text: message)]),
    ];

    final requestBody = ChatSessionRequest(
      generationConfig: GenerationConfig(
        temperature: 1,
        topP: 0.95,
        topK: 64,
        maxOutputTokens: 65536,
        responseModalities: [],
        responseMimeType: "text/plain",
      ),
      contents: allContents, // Use 'contents' here
    );

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return ChatSessionResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to send message: ${response.statusCode}, ${response.body}',
      );
    }
  }

  void _handleSubmit() async {
    final input = _nameController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add("You: $input");
      _history.add(Content(role: "user", parts: [Part(text: input)]));
    });
    _nameController.clear();

    try {
      final response = await _sendMessageToChatbot(input);
      if (response.candidates != null && response.candidates!.isNotEmpty) {
        final botResponse = response.candidates!.first.content.parts
            .map((p) => p.text)
            .join('\n');
        setState(() {
          _messages.add("Bot: $botResponse");
          _history.add(
            Content(role: "model", parts: [Part(text: botResponse)]),
          );
        });
      } else {
        setState(() {
          _messages.add("Bot: Error receiving response.");
        });
      }
    } catch (e) {
      setState(() {
        _messages.add("Bot: An error occurred: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Nutrition Chatbot"),
      ),
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
                        child: Icon(
                          Icons.android,
                          size: 30,
                          color: Colors.blueAccent,
                        ),
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
    bool isUser = text.startsWith("You:");
    final message = text.replaceFirst("You: ", "").replaceFirst("Bot: ", "");

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.smart_toy,
                    color: Colors.blueAccent,
                    size: 22,
                  ),
                ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blueAccent : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft:
                          isUser ? Radius.circular(20) : Radius.circular(0),
                      bottomRight:
                          isUser ? Radius.circular(0) : Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.copy, size: 18, color: Colors.grey[600]),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: message));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Copied to clipboard")),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share, size: 18, color: Colors.green),
                    onPressed: () {
                      Share.share(message); // Opens share sheet
                    },
                  ),
                ],
              ),
            ),
        ],
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
    return Center();
  }
}
