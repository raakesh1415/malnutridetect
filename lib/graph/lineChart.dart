import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:malnutridetect/graph/pricePoints.dart';

class LineChartWidget extends StatelessWidget {
  final List<PricePoint> points;
  const LineChartWidget(this.points, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true, // Corrected syntax
              dotData: FlDotData(show: true), // Added missing comma
            ),
          ],
        ),
      ),
    );
  }
}
