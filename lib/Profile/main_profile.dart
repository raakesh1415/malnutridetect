import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:malnutridetect/auth/main_page.dart';
import 'package:malnutridetect/register/login_page.dart';
import 'package:malnutridetect/register/register_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            // Use TextButton.icon for a text + icon button
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            icon: Icon(Icons.logout), // Use a logout icon
            label: Text('Sign Out'),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut(); // ✅ await is required
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (route) => false,
                );
              } catch (e) {
                print('Error signing out: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error signing out. Please try again.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150',
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[200],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white, size: 20),
                      onPressed: () {
                        // Handle profile picture edit
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Form Fields
            _buildTextField(
              labelText: 'Full Name',
              initialValue: 'Demon',
              icon: Icons.person,
            ),
            _buildTextField(
              labelText: 'Username', // Changed from Email to Username
              initialValue: 'damon90', // Changed initial value
              icon: Icons.person_outline, // Changed icon
            ),
            _buildTextField(
              labelText: 'Email', // Changed from Password to Email
              initialValue:
                  'damon90@gmail.com', // Changed initial value - NO ASTERISKS
              icon: Icons.email, // Changed icon
            ),
            _buildTextField(
              labelText: 'Password', // Changed from Location to Password
              initialValue: '********', // Changed initial value
              icon: Icons.lock, // Changed icon
              obscureText: true,
              suffixIcon: IconButton(
                icon: Icon(Icons.visibility),
                onPressed: () {
                  // Toggle password visibility
                },
              ),
            ),
            SizedBox(height: 40),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle cancel action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('CANCEL'),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle save action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('SAVE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required String initialValue,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.blue[700]),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
