import 'package:flutter/material.dart';
import 'package:malnutridetect/input/indicatorDetailPage.dart';

class Insights extends StatelessWidget {
  final List<Map<String, String>> infoSections = [
    {
      'title': 'What do these indicators tell us?',
      'content': '''
The indicators stunting, wasting, overweight and underweight are used to measure nutritional imbalance; such imbalance results in either undernutrition (assessed from stunting, wasting and underweight) or overweight. Child growth is internationally recognized as an important indicator of nutritional status and health in populations.

The percentage of children with a low height-for-age (stunting) reflects the cumulative effects of undernutrition and infections since birth, and even before birth. This measure can therefore be interpreted as an indication of poor environmental conditions or long-term restriction of a child's growth potential. The percentage of children who have low weight-for-age (underweight) can reflect wasting (i.e. low weight-for-height), indicating acute weight loss or stunting, or both. Thus, underweight is a composite indicator that may be difficult to interpret.

Stunting, wasting and overweight in children aged under 5 years are included as primary outcome indicators in the core set of indicators for the Global Nutrition Monitoring Framework to monitor progress towards reaching Global Nutrition Targets 1, 4 and 6. These three indicators are also included in WHO's Global reference list of 100 core health indicators.
      ''',
    },
    {'title': 'How are these indicators defined?', 'content': ''},
    {
      'title': 'What are the consequences and implications?',
      'content': '''
**Stunting**  
Children who suffer from growth retardation due to poor diets or infections are at higher risk of illness and death. It leads to delayed mental development, poor school performance, reduced intellectual capacity, and future economic challenges. Short-statured women may face complications during childbirth and are more likely to deliver low birth weight infants, continuing the cycle of malnutrition.

**Wasting**  
A sign of acute undernutrition, usually due to insufficient food intake or frequent infections like diarrhea. It weakens the immune system, increasing the severity and risk of diseases and death.

**Overweight**  
Linked with a greater chance of obesity in adulthood, leading to serious health issues such as:
- Cardiovascular diseases (heart disease, stroke)  
- Diabetes  
- Musculoskeletal disorders (especially osteoarthritis)  
- Cancers (endometrium, breast, colon)

**Underweight**  
Easy to measure but concerning. Even mild underweight raises mortality risk in children, with higher risk in severely underweight cases.
      ''',
    },
    {'title': 'Cut-off values for public health significance', 'content': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Malnutrition Information"),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: infoSections.length,
        itemBuilder: (context, index) {
          final section = infoSections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => IndicatorDetailPage(
                          title: section['title']!,
                          content: section['content']!,
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 30,
                      color: Colors.blue[900],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        section['title']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
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
