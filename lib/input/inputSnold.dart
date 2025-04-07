import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  int _selectedIndex = 0;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController cmController = TextEditingController();
  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchController = TextEditingController();
  final TextEditingController kgController = TextEditingController();
  final TextEditingController lbsController = TextEditingController();

  String selectedGender = "Male";
  bool isHeightMetric = true;
  bool isWeightMetric = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Malnutrition Risk Input"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildSectionTitle("👤 Gender"),
            Row(
              children: [
                _genderRadio("Male", Icons.male),
                SizedBox(width: 20),
                _genderRadio("Female", Icons.female),
              ],
            ),
            SizedBox(height: 20),
            _buildSectionTitle("🎂 Age"),
            _buildCard(
              child: TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter your age",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildSectionTitle("📏 Height"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Unit:", style: TextStyle(fontWeight: FontWeight.w600)),
                DropdownButton<bool>(
                  value: isHeightMetric,
                  items: [
                    DropdownMenuItem(child: Text("cm"), value: true),
                    DropdownMenuItem(child: Text("ft-in"), value: false),
                  ],
                  onChanged: (val) => setState(() => isHeightMetric = val!),
                ),
              ],
            ),
            isHeightMetric
                ? _buildCard(
                  child: TextField(
                    controller: cmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Height in cm",
                      border: InputBorder.none,
                    ),
                  ),
                )
                : Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        child: TextField(
                          controller: feetController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Feet",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildCard(
                        child: TextField(
                          controller: inchController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Inches",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            SizedBox(height: 20),
            _buildSectionTitle("⚖️ Weight"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Unit:", style: TextStyle(fontWeight: FontWeight.w600)),
                DropdownButton<bool>(
                  value: isWeightMetric,
                  items: [
                    DropdownMenuItem(child: Text("kg"), value: true),
                    DropdownMenuItem(child: Text("lbs"), value: false),
                  ],
                  onChanged: (val) => setState(() => isWeightMetric = val!),
                ),
              ],
            ),
            isWeightMetric
                ? _buildCard(
                  child: TextField(
                    controller: kgController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Weight in kg",
                      border: InputBorder.none,
                    ),
                  ),
                )
                : _buildCard(
                  child: TextField(
                    controller: lbsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Weight in lbs",
                      border: InputBorder.none,
                    ),
                  ),
                ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submitData,
              icon: Icon(Icons.analytics_rounded),
              label: Text(
                "Check Malnutrition Risk",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[400], // Ensure a dark enough background
        selectedItemColor:
            Colors.white, // White for the selected item (high contrast)
        unselectedItemColor: Colors.white70, // Light white for unselected items
        currentIndex: _selectedIndex, // Track selected index
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: "DAILY", // Ensure label is readable against background
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: "INSIGHT", // Ensure label is readable against background
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "PROFILE", // Ensure label is readable against background
          ),
        ],
      ),
    );
  }

  Widget _genderRadio(String gender, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selectedGender == gender ? Colors.blue[200] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        child: RadioListTile<String>(
          value: gender,
          groupValue: selectedGender,
          title: Row(
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 8),
              Text(gender),
            ],
          ),
          onChanged: (value) => setState(() => selectedGender = value!),
          activeColor: Colors.blue[900],
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  void _submitData() {
    String gender = selectedGender;
    int? age = int.tryParse(ageController.text);

    double? height;
    if (isHeightMetric) {
      height = double.tryParse(cmController.text);
    } else {
      double? ft = double.tryParse(feetController.text);
      double? inch = double.tryParse(inchController.text);
      if (ft != null && inch != null) {
        height = (ft * 30.48) + (inch * 2.54); // Convert to cm
      }
    }

    double? weight;
    if (isWeightMetric) {
      weight = double.tryParse(kgController.text);
    } else {
      double? lbs = double.tryParse(lbsController.text);
      if (lbs != null) {
        weight = lbs * 0.453592; // Convert to kg
      }
    }

    if (age != null && height != null && weight != null) {
      print(
        "GENDER: $gender, AGE: $age, HEIGHT: $height cm, WEIGHT: $weight kg",
      );
      // Add your malnutrition analysis logic here or navigate to result screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields properly.")),
      );
    }
  }
}
