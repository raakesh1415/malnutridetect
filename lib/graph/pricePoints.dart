import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

// Define a getter function correctly
List<PricePoint> get pricePoints {
  final data = <double>[2, 4, 6, 7, 10, 5]; // Missing semicolon fixed

  return data
      .mapIndexed(
        (index, element) => PricePoint(x: index.toDouble(), y: element.toDouble()),
      )
      .toList();
}
