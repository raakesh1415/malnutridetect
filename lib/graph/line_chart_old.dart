import 'dart:typed_data';
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

  void _printGraph() async {
    final Uint8List? image = await screenshotController.capture();

    if (image != null) {
      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(image);

      // Add page to the PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Title at the top of the page
                pw.Text(
                  'Growth Chart',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF0000FF), // Blue color
                  ),
                ),
                pw.SizedBox(height: 20), // Space between title and chart
                // Description text below the title
                pw.Text(
                  'This chart shows the malnutrition trend over time.',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromInt(0xFF000000), // Black color
                  ),
                ),
                pw.SizedBox(height: 15), // Space between text and image
                // Ensure the image fits within constraints, size can be adjusted
                pw.Center(
                  child: pw.Container(
                    width: 800, // Set width limit
                    height: 600, // Set height limit
                    child: pw.Image(
                      pdfImage,
                      fit:
                          pw
                              .BoxFit
                              .contain, // Ensure the image is contained within the bounds
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Send the PDF to the printer
      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
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
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.white,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
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
                        spots: [
                          FlSpot(0, 2),
                          FlSpot(1, 4),
                          FlSpot(2, 6),
                          FlSpot(3, 7),
                          FlSpot(4, 10),
                          FlSpot(5, 5),
                        ],
                        isCurved: true,
                        color: Colors.blue[900],
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightBlue.withOpacity(0.3),
                              Colors.lightBlueAccent.withOpacity(0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter:
                              (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.deepPurple,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
          SizedBox(height: 20),
        ],
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
