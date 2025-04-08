import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class LineChartScreen extends StatefulWidget {
  const LineChartScreen({Key? key}) : super(key: key);

  @override
  _LineChartScreenState createState() => _LineChartScreenState();
}

class _LineChartScreenState extends State<LineChartScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  int _selectedIndex = 0;

  List<FlSpot> wazSpots = [];
  List<FlSpot> hazSpots = [];
  List<FlSpot> whzSpots = [];
  List<String> dateLabels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserChartData();
  }

  Future<void> fetchUserChartData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('malnutrition_records')
            .where('userId', isEqualTo: currentUser.uid)
            .orderBy('timestamp', descending: true)
            .get();

    List<FlSpot> waz = [];
    List<FlSpot> haz = [];
    List<FlSpot> whz = [];
    List<String> labels = [];

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      final doc = querySnapshot.docs[i];
      final data = doc.data();

      final double? wazValue = (data['waz'] as num?)?.toDouble();
      final double? hazValue = (data['haz'] as num?)?.toDouble();
      final double? whzValue = (data['whz'] as num?)?.toDouble();

      Timestamp? timestamp;
      if (data['timestamp'] is Timestamp) {
        timestamp = data['timestamp'] as Timestamp;
      } else if (data['timestamp'] is String) {
        timestamp = Timestamp.fromDate(DateTime.parse(data['timestamp']));
      }

      String formattedDate = '';
      if (timestamp != null) {
        final date = timestamp.toDate();
        formattedDate =
            "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
        labels.add(formattedDate);
      } else {
        labels.add("N/A");
      }

      if (wazValue != null) waz.add(FlSpot(i.toDouble(), wazValue));
      if (hazValue != null) haz.add(FlSpot(i.toDouble(), hazValue));
      if (whzValue != null) whz.add(FlSpot(i.toDouble(), whzValue));
    }

    setState(() {
      wazSpots = waz;
      hazSpots = haz;
      whzSpots = whz;
      dateLabels = labels;
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
                  'Child Health Chart',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF0000FF),
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  'This chart displays WAZ, HAZ, and WHZ trends over time based on input records.',
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
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, _) {
                final int index = value.toInt();
                if (index >= 0 && index < dateLabels.length) {
                  return Text(
                    dateLabels[index],
                    style: TextStyle(fontSize: 10),
                  );
                } else {
                  return Text('');
                }
              },
            ),
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
              getDotPainter:
                  (spot, percent, barData, index) => FlDotCirclePainter(
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
      appBar: AppBar(
        title: Text('Child Health Chart'),
        backgroundColor: Colors.blue[400],
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ), // Add right padding here
            child: IconButton(
              icon: Icon(Icons.print_outlined, color: Colors.black87),
              tooltip: 'Print or Save PDF',
              onPressed: _printGraph,
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Screenshot(
                  controller: screenshotController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                          'WAZ (Weight-for-Age)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: buildChart(wazSpots, 'WAZ', Colors.orange),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                          'HAZ (Height-for-Age)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: buildChart(hazSpots, 'HAZ', Colors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                          'WHZ (Weight-for-Height)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: buildChart(whzSpots, 'WHZ', Colors.green),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
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
}
