//indicatorDetailPage.dart
import 'package:flutter/material.dart';

class IndicatorDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const IndicatorDetailPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? specialContent;

    // Add special content for specific sections
    if (title == 'Malnutrition indicators') {
      specialContent = _buildDefinitionTable();
    } else if (title == 'Cut-off values for public health significance') {
      specialContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCutoffTable('Stunting', [
            ['Very low', '< 2.5%'],
            ['Low', '2.5 - < 10%'],
            ['Medium', '10 - < 20%'],
            ['High', '20 - < 30%'],
            ['Very high', '≥ 30%'],
          ]),
          SizedBox(height: 16),
          _buildCutoffTable('Wasting', [
            ['Very low', '< 2.5%'],
            ['Low', '2.5 - < 5%'],
            ['Medium', '5 - < 10%'],
            ['High', '10 - < 15%'],
            ['Very high', '≥ 15%'],
          ]),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[400],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display formatted content with markdown-style bold text
              _buildFormattedText(content),
              SizedBox(height: 24),
              // Display special content if available
              if (specialContent != null) specialContent,
            ],
          ),
        ),
      ),
    );
  }

  // Method to handle markdown-style formatting
  Widget _buildFormattedText(String text) {
    // Split the content by line breaks to handle bullets separately
    List<String> lines = text.split('\n');
    List<Widget> textWidgets = [];

    for (String line in lines) {
      // Check if the line is a bullet point
      if (line.trim().startsWith('- ')) {
        textWidgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: _buildRichText(line.trim().substring(2)),
                ),
              ],
            ),
          ),
        );
      } else {
        // Handle regular text with potential bold sections
        textWidgets.add(_buildRichText(line));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: textWidgets,
    );
  }

  // Helper method to process markdown-style bold text (**bold**)
  Widget _buildRichText(String text) {
    List<TextSpan> spans = [];
    
    // Pattern to match **bold text**
    RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
    
    // Start position for scanning the text
    int currentPosition = 0;
    
    // Find all bold patterns in the text
    for (Match match in boldPattern.allMatches(text)) {
      // Add any text before the bold pattern
      if (match.start > currentPosition) {
        spans.add(TextSpan(
          text: text.substring(currentPosition, match.start),
          style: TextStyle(fontSize: 16),
        ));
      }
      
      // Add the bold text without the ** markers
      spans.add(TextSpan(
        text: match.group(1), // The text inside ** markers
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ));
      
      // Update the current position
      currentPosition = match.end;
    }
    
    // Add any remaining text after the last bold pattern
    if (currentPosition < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPosition),
        style: TextStyle(fontSize: 16),
      ));
    }
    
    // If no bold patterns were found, check if this is an indicator line
    // (specific to the Malnutrition indicators section)
    if (spans.isEmpty && text.contains(':')) {
      List<String> parts = text.split(':');
      if (parts.length == 2) {
        spans = [
          TextSpan(
            text: parts[0].trim() + ': ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          TextSpan(
            text: parts[1].trim(),
            style: TextStyle(fontSize: 16),
          ),
        ];
      } else {
        spans = [TextSpan(text: text, style: TextStyle(fontSize: 16))];
      }
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: spans.isEmpty ? [TextSpan(text: text, style: TextStyle(fontSize: 16))] : spans,
        ),
      ),
    );
  }

  TableRow _buildTableRow(String col1, String col2) {
    return TableRow(
      children: [
        Padding(padding: EdgeInsets.all(8), child: Text(col1)),
        Padding(padding: EdgeInsets.all(8), child: Text(col2)),
      ],
    );
  }

  Table _buildDefinitionTable() {
    return Table(
      border: TableBorder.all(width: 1, color: Colors.grey.shade400),
      columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(5)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.blue.shade100),
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Indicator",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Definition",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        _buildTableRow(
          "Stunting",
          "Height-for-age < -2 SD of WHO Child Growth Standards",
        ),
        _buildTableRow(
          "Wasting",
          "Weight-for-height < -2 SD of WHO Child Growth Standards",
        ),
        _buildTableRow(
          "Overweight",
          "Weight-for-height > +2 SD of WHO Child Growth Standards",
        ),
        _buildTableRow(
          "Underweight",
          "Weight-for-age < -2 SD of WHO Child Growth Standards",
        ),
      ],
    );
  }

  Table _buildCutoffTable(String indicator, List<List<String>> rows) {
    return Table(
      border: TableBorder.all(width: 1, color: Colors.grey.shade400),
      columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.green.shade100),
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "$indicator Prevalence",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Cut-off Values",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...rows.map((row) => _buildTableRow(row[0], row[1])),
      ],
    );
  }
}