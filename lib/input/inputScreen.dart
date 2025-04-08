import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:malnutridetect/input/resultListPage.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  int _selectedIndex = 0;
  String? selectedGender;
  String? resultText;
  bool _hasRisk = false;

  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  List<dynamic> whzData = [];
  List<dynamic> hazData = [];
  List<dynamic> wazData = [];

  @override
  void initState() {
    super.initState();
    _loadDatasets();
  }

  Future<void> _loadDatasets() async {
    final whzJson = await rootBundle.loadString('datasets/whz.json');
    final hazJson = await rootBundle.loadString('datasets/haz.json');
    final wazJson = await rootBundle.loadString('datasets/waz.json');
    setState(() {
      whzData = json.decode(whzJson);
      hazData = json.decode(hazJson);
      wazData = json.decode(wazJson);
    });
  }

  double? calculateZScore(double L, double M, double S, double X) {
    try {
      return L == 0 ? log(X / M) / S : (pow(X / M, L) - 1) / (L * S);
    } catch (_) {
      return null;
    }
  }

  dynamic findClosest(
    List<dynamic> data,
    String gender,
    String field,
    double value,
  ) {
    final filtered =
        data
            .where(
              (item) => item['Gender'].toLowerCase() == gender.toLowerCase(),
            )
            .toList();
    filtered.sort((a, b) {
      final aVal = (a[field] as num).toDouble();
      final bVal = (b[field] as num).toDouble();
      return (aVal - value).abs().compareTo((bVal - value).abs());
    });
    return filtered.isNotEmpty ? filtered.first : null;
  }

  String interpretZScore(double z, String type) {
    switch (type) {
      case 'HAZ':
        if (z < -2) return '📉 Stunted (Height-for-age < -2 SD)';
        break;
      case 'WHZ':
        if (z < -2) return '📉 Wasted (Weight-for-height < -2 SD)';
        if (z > 2) return '⚠️ Overweight (Weight-for-height > +2 SD)';
        break;
      case 'WAZ':
        if (z < -2) return '📉 Underweight (Weight-for-age < -2 SD)';
        break;
    }
    return '✅ Normal';
  }

  void _submitData() async {
    String gender = genderController.text;
    int? age = int.tryParse(ageController.text);
    double? height = double.tryParse(heightController.text);
    double? weight = double.tryParse(weightController.text);

    if (gender.isNotEmpty && age != null && height != null && weight != null) {
      final whzRow = findClosest(whzData, gender, "Length", height);
      final hazRow = findClosest(hazData, gender, "Month", age.toDouble());
      final wazRow = findClosest(wazData, gender, "Month", age.toDouble());

      if (whzRow == null || hazRow == null || wazRow == null) {
        setState(
          () => resultText = "❌ Error: Could not find matching LMS data.",
        );
        return;
      }

      double? whz = calculateZScore(
        (whzRow["L"] as num).toDouble(),
        (whzRow["M"] as num).toDouble(),
        (whzRow["S"] as num).toDouble(),
        weight,
      );
      double? haz = calculateZScore(
        (hazRow["L"] as num).toDouble(),
        (hazRow["M"] as num).toDouble(),
        (hazRow["S"] as num).toDouble(),
        height,
      );
      double? waz = calculateZScore(
        (wazRow["L"] as num).toDouble(),
        (wazRow["M"] as num).toDouble(),
        (wazRow["S"] as num).toDouble(),
        weight,
      );

      String whzResult = interpretZScore(whz ?? 0, 'WHZ');
      String hazResult = interpretZScore(haz ?? 0, 'HAZ');
      String wazResult = interpretZScore(waz ?? 0, 'WAZ');
      bool hasRisk = [
        whzResult,
        hazResult,
        wazResult,
      ].any((r) => !r.contains("Normal"));

      DateTime timestamp = DateTime.now();
      _hasRisk = hasRisk;
      String formattedResult = """
🔍 MALNUTRITION ANALYSIS RESULT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👤 Personal Information:
  • Gender: $gender
  • Age: $age months
  • Height: ${height.toStringAsFixed(1)} cm
  • Weight: ${weight.toStringAsFixed(1)} kg

📊 Results:
  • Weight-for-Height (WHZ): ${whz?.toStringAsFixed(2) ?? 'N/A'} 
    ${whzResult}
  • Height-for-Age (HAZ): ${haz?.toStringAsFixed(2) ?? 'N/A'} 
    ${hazResult}
  • Weight-for-Age (WAZ): ${waz?.toStringAsFixed(2) ?? 'N/A'} 
    ${wazResult}

📝 SUMMARY: ${hasRisk ? '⚠️ MALNUTRITION RISK' : '✅ NORMAL STATUS'}

🕒 Assessment Date: ${timestamp.toLocal().toString().substring(0, 16)}
""";

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('malnutrition_records').add(
          {
            'userId': user.uid,
            'gender': gender,
            'age': age,
            'height': height,
            'weight': weight,
            'timestamp': timestamp.toIso8601String(),
            'result': formattedResult,
            'whz': whz, // 🔄 Added WHZ value
            'haz': haz, // 🔄 Added HAZ value
            'waz': waz, // 🔄 Added WAZ value
            'whz_status': whzResult,
            'haz_status': hazResult,
            'waz_status': wazResult,
            'hasRisk': hasRisk,
          },
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultListPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields properly.")),
      );
    }
  }

  @override
  void dispose() {
    genderController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Malnutrition Risk Input"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter your age (months)",
                  border: InputBorder.none,
                ),
              ),
            ),
            _buildSectionTitle("📏 Height"),
            _buildCard(
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter height in cm",
                  border: InputBorder.none,
                ),
              ),
            ),
            _buildSectionTitle("⚖️ Weight"),
            _buildCard(
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter weight in kg",
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
            if (resultText != null) _buildResultCard(resultText!),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[400],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "DAILY"),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: "INSIGHT"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
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
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
              genderController.text = value;
            });
          },
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

  Widget _buildCard(Widget child) {
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

  Widget _buildResultCard(String result) {
    final cardColor = _hasRisk ? Colors.red.shade100 : Colors.green.shade100;
    final borderColor = _hasRisk ? Colors.red : Colors.green;
    final textColor = _hasRisk ? Colors.red[900] : Colors.green[900];

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.4),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        result,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
