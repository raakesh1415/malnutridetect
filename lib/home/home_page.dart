import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:malnutridetect/graph/pricePoints.dart';
import 'package:malnutridetect/graph/line_chart_screen.dart';
import 'package:malnutridetect/chatbot/chatbotScreen.dart';
import 'package:malnutridetect/input/inputScreen.dart';
import 'package:malnutridetect/Profile/main_profile.dart';
import 'package:malnutridetect/input/insights.dart';
import 'package:malnutridetect/input/resultListPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  // Variable to keep track of the selected index
  int _selectedIndex = 0;
  int? _selectedCardIndex; // Variable to keep track of selected card

  @override
  Widget build(BuildContext context) {
    // Get current date in Malaysia timezone
    DateTime now = DateTime.now().toUtc().add(
      Duration(hours: 8),
    ); // Malaysia is UTC+8
    String formattedDate = DateFormat(
      'MMM dd',
    ).format(now); // Example: "Dec 26"
    String formattedDay = DateFormat('EEEE').format(now); // Example: "Tuesday"

    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[400],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex, // Set the selected index here
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index when tapped
          });
          // Navigate to ProfilePage when the profile icon is tapped
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Insights(),
              ), // Navigate to MainProfile
            );
          }
          // Navigate to ProfilePage when the profile icon is tapped
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ), // Navigate to MainProfile
            );
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "DAILY"),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: "INSIGHT"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              Text(
                formattedDay,
                style: TextStyle(fontSize: 18, color: Colors.blue[700]),
              ),
              SizedBox(height: 30),
              Text(
                "Malnutrition Tracker",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 10),
              _buildHealthCard(
                index: 0,
                icon: Icons.health_and_safety,
                title: "Check Malnutrition Risk",
                subtitle: "Assess the malnutrition risk today!",
                buttonText: "Check Now",
                buttonColor: Colors.blue[700]!,
                onTap: () {
                  // Perform action for "Check Malnutrition Risk"
                  //_handleCardAction("Check Malnutrition Risk", 0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputScreen()),
                  );
                },
              ),
              _buildHealthCard(
                index: 1,
                icon: Icons.show_chart,
                title: "Track Growth",
                subtitle: "Monitor your growth progress.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LineChartScreen()),
                  );
                },
              ),
              _buildHealthCard(
                index: 1,
                icon: Icons.folder_outlined,
                title: "Malnutrition Records",
                subtitle: "View malnutrition anaylsis results.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultListPage()),
                  );
                },
              ),
              SizedBox(height: 30),
              Text(
                "AI Assistance",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 10),
              // _buildHealthCard(
              //   index: 2,
              //   icon: Icons.restaurant_menu,
              //   title: "Nutrition Plan",
              //   subtitle: "Get personalized nutrition advice.",
              //   onTap: () {
              //     _handleCardAction("Nutrition Plan", 2);
              //   },
              // ),
              _buildHealthCard(
                index: 3,
                icon: Icons.chat,
                title: "AI Chatbot",
                subtitle: "Ask the AI chatbot for guidance.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatbotPage()),
                  );
                },
              ),
              //SizedBox(height: 20),
              // Text('Signed In as: ${user.email!}'),
              // MaterialButton(
              //   onPressed: () {
              //     FirebaseAuth.instance.signOut();
              //   },
              //   color: Colors.blueAccent[200],
              //   child: Text('Sign Out'),
              // ),
              // SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard({
    required int index,
    required IconData icon,
    required String title,
    String? subtitle,
    String? buttonText,
    Color? buttonColor,
    required Function onTap,
  }) {
    bool isSelected =
        _selectedCardIndex == index; // Check if the card is selected

    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        color:
            isSelected
                ? Colors.blue[200]
                : Colors.blue[100], // Highlight selected card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side:
              isSelected
                  ? BorderSide(color: Colors.blue[700]!, width: 2)
                  : BorderSide.none,
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.blue[900], size: 36),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    subtitle,
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ),
              if (buttonText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                    ),
                    onPressed: () => onTap(),
                    child: Text(
                      buttonText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          trailing:
              buttonText == null
                  ? Icon(Icons.arrow_forward_ios, color: Colors.blue[700])
                  : null,
        ),
      ),
    );
  }

  void _handleCardAction(String action, int index) {
    // Update the selected card
    setState(() {
      _selectedCardIndex = index;
    });

    // Handle actions based on the selected card
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Action Selected"),
          content: Text("You selected: $action"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
