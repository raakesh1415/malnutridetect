import 'package:flutter/material.dart';

class IndicatorDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const IndicatorDetailPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title == 'What do these indicators tell us?') ...[
                _buildDescriptionText(content),
              ],
              if (title == 'What are the consequences and implications?') ...[
                _buildFormattedText(content),
              ],
              if (title == 'How are these indicators defined?') ...[
                _buildDefinitionTable(),
              ],
              if (title == 'Cut-off values for public health significance') ...[
                _buildCutoffTable('Stunting', [
                  ['Very Low', '<2.5%'],
                  ['Low', '2.5% to <10%'],
                  ['Medium', '10% to <20%'],
                  ['High', '20% to <30%'],
                  ['Very High', '≥30%'],
                ]),
                SizedBox(height: 20),
                _buildCutoffTable('Wasting', [
                  ['Very Low', '<2.5%'],
                  ['Low', '2.5% to <5%'],
                  ['Medium', '5% to <10%'],
                  ['High', '10% to <15%'],
                  ['Very High', '≥15%'],
                ]),
                SizedBox(height: 20),
                _buildCutoffTable('Overweight', [
                  ['Very Low', '<2.5%'],
                  ['Low', '2.5% to <5%'],
                  ['Medium', '5% to <10%'],
                  ['High', '10% to <15%'],
                  ['Very High', '≥15%'],
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionText(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
    );
  }

  Widget _buildFormattedText(String content) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black87),
        children: [
          TextSpan(
            text: 'Stunting\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                'Children who suffer from growth retardation due to poor diets or infections are at higher risk of illness and death. It leads to delayed mental development, poor school performance, reduced intellectual capacity, and future economic challenges.\n\n',
          ),
          TextSpan(
            text: 'Wasting\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                'A sign of acute undernutrition, usually due to insufficient food intake or frequent infections like diarrhea. It weakens the immune system, increasing the severity and risk of diseases and death.\n\n',
          ),
          TextSpan(
            text: 'Overweight\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                'Linked with a greater chance of obesity in adulthood, leading to serious health issues such as: Cardiovascular diseases, diabetes, musculoskeletal disorders, cancers (endometrium, breast, colon).\n\n',
          ),
          TextSpan(
            text: 'Underweight\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                'Easy to measure but concerning. Even mild underweight raises mortality risk in children, with higher risk in severely underweight cases.\n\n',
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionTable() {
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

  TableRow _buildTableRow(String col1, String col2) {
    return TableRow(
      children: [
        Padding(padding: EdgeInsets.all(8), child: Text(col1)),
        Padding(padding: EdgeInsets.all(8), child: Text(col2)),
      ],
    );
  }

  Widget _buildCutoffTable(String indicator, List<List<String>> rows) {
    return Table(
      border: TableBorder.all(width: 1, color: Colors.grey.shade400),
      columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
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
                "Prevalence Cut-off",
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
