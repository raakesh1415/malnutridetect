import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class LineChartScreen extends StatefulWidget {
  @override
  _LineChartScreenState createState() => _LineChartScreenState();
}

class _LineChartScreenState extends State<LineChartScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  int _selectedIndex = 0;

  List<FlSpot> wazSpots = [];
  List<FlSpot> hazSpots = [];
  List<FlSpot> whzSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserChartData();
  }

  Future<void> fetchUserChartData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('malnutrition_records')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .get();

    List<FlSpot> waz = [];
    List<FlSpot> haz = [];
    List<FlSpot> whz = [];

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      final doc = querySnapshot.docs[i];
      final data = doc.data();
      final double? wazValue = (data['waz'] as num?)?.toDouble();
      final double? hazValue = (data['haz'] as num?)?.toDouble();
      final double? whzValue = (data['whz'] as num?)?.toDouble();

      if (wazValue != null) waz.add(FlSpot(i.toDouble(), wazValue));
      if (hazValue != null) haz.add(FlSpot(i.toDouble(), hazValue));
      if (whzValue != null) whz.add(FlSpot(i.toDouble(), whzValue));
    }

    setState(() {
      wazSpots = waz;
      hazSpots = haz;
      whzSpots = whz;
      isLoading = false;
    });
  }

  void _printGraph() async {
    final Uint8List? image = await screenshotController.capture();

    if (image != null) {
      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(image);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Growth Chart',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF0000FF),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'This chart shows the malnutrition trend over time.',
                  style: pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 15),
                pw.Center(
                  child: pw.Container(
                    width: 800,
                    height: 600,
                    child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
                  ),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    }
  }

  LineChart buildChart(List<FlSpot> dataSpots, String label, Color color) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(enabled: true),
        backgroundColor: Colors.white,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: dataSpots,
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 4,
                    color: color,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Growth Chart", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[400],
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.print, color: Colors.white),
            onPressed: _printGraph,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Screenshot(
              controller: screenshotController,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("WAZ Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 200, child: buildChart(wazSpots, "WAZ", Colors.blue)),
                      SizedBox(height: 20),
                      Text("HAZ Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 200, child: buildChart(hazSpots, "HAZ", Colors.green)),
                      SizedBox(height: 20),
                      Text("WHZ Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 200, child: buildChart(whzSpots, "WHZ", Colors.deepOrange)),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _printGraph,
                        icon: Icon(Icons.print),
                        label: Text("Print Chart"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          backgroundColor: Colors.blue[400],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[400],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "DAILY"),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: "INSIGHT"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
        ],
      ),
    );
  }
}


