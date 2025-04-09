import 'package:flutter/material.dart';
import 'package:malnutridetect/Profile/main_profile.dart';
import 'package:malnutridetect/home/home_page.dart';
import 'package:malnutridetect/input/indicatorDetailPage.dart';

class Insights extends StatefulWidget {
  const Insights({Key? key}) : super(key: key);

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  // Variable to keep track of the selected index
  int _selectedIndex = 1;

  final List<Map<String, dynamic>> infoSections = [
    {
      'title': 'Malnutrition',
      'content': '''
Your body needs a variety of nutrients, and in certain amounts, to maintain its tissues and its many functions. Malnutrition happens when the nutrients it gets don't meet these needs. You can be malnourished from an overall lack of nutrients, or you may have an abundance of some kinds of nutrients but lack other kinds. Even the lack of a single vitamin or mineral can have serious health consequences for your body. On the other hand, having an excess of nutrients can also cause problems.
      ''',
      'icon': Icons.medical_information_outlined,
      'color': Colors.red,
    },
    {
      'title': 'Types of malnutrition',
      'content': '''
Malnutrition can mean undernutrition or overnutrition. It can also mean an imbalance of macronutrients (proteins, carbohydrates, fats) or micronutrients (vitamins and minerals).

**Undernutrition**
Undernutrition is what most people think of when they think of malnutrition. Undernutrition is a deficiency of nutrients. You may be undernourished if you don't have an adequate diet, or if your body has trouble absorbing enough nutrients from your food. Undernutrition can cause visible wasting of fat and muscle, but it can also be invisible. You can be overweight and undernourished.

**Macronutrient undernutrition**
Also called protein-energy undernutrition, this is a deficiency of macronutrients: proteins, carbohydrates and fats. Macronutrients are the main building blocks of your diet, the nutrients that your body relies on to produce energy to maintain itself. Without them — or even just one of them — your body soon begins to fall apart, breaking down tissues and shutting down nonessential functions to conserve its low energy.

**Micronutrient undernutrition**
Micronutrients are vitamins and minerals. Your body needs these in smaller amounts, but it does need them, for all types of functions. Many people are mildly deficient in certain vitamins and minerals from a lack of variety in their diet. You might not notice a mild vitamin deficiency affecting you, but as micronutrient undernutrition becomes more severe, it can begin to have serious and lasting effects.

**Overnutrition**
The World Health Organization has recently added overnutrition to its definition of malnutrition to recognize the detrimental health effects that can be caused by excessive consumption of nutrients. This includes the effects of overweight and obesity, which are strongly associated with a list of noncommunicable diseases (NCDs). It also includes the toxicity that can result from overdosing specific micronutrients.

**Macronutrient overnutrition**
When your body has an excess of protein, carbohydrate and/or fat calories to use, it stores them away as fat cells in your adipose tissue. But when your body runs out of tissue for storage, the fat cells themselves have to grow. Enlarged fat cells are associated with chronic inflammation and with a host of metabolic disorders that follow. These can lead to NCDs such as diabetes mellitus, coronary artery disease and stroke.

**Micronutrient overnutrition**
You can actually overdose on vitamin and mineral supplements. More research is needed to explain how this happens and how much is too much of a certain vitamin or mineral. In general, micronutrient overnutrition is uncommon and doesn't occur from diet alone. But if you take mega doses of certain supplements, it can have toxic effects. It's a good idea to check with your healthcare provider first.
      ''',
      'icon': Icons.category_outlined,
      'color': Colors.purple,
    },
    {
      'title': 'Malnutrition diagnosis',
      'content': '''
The indicators stunting, wasting, overweight and underweight are used to measure nutritional imbalance; such imbalance results in either undernutrition (assessed from stunting, wasting and underweight) or overweight. Child growth is internationally recognized as an important indicator of nutritional status and health in populations.

The percentage of children with a low height-for-age (stunting) reflects the cumulative effects of undernutrition and infections since birth, and even before birth. This measure can therefore be interpreted as an indication of poor environmental conditions or long-term restriction of a child's growth potential. The percentage of children who have low weight-for-age (underweight) can reflect wasting (i.e. low weight-for-height), indicating acute weight loss or stunting, or both. Thus, underweight is a composite indicator that may be difficult to interpret.

Stunting, wasting and overweight in children aged under 5 years are included as primary outcome indicators in the core set of indicators for the Global Nutrition Monitoring Framework to monitor progress towards reaching Global Nutrition Targets 1, 4 and 6. These three indicators are also included in WHO's Global reference list of 100 core health indicators.
      ''',
      'icon': Icons.monitor_weight_outlined,
      'color': Colors.cyan,
    },
    {
      'title': 'Malnutrition indicators',
      'content': '''
**Indicators and Definitions:**

- **Stunting**: Height-for-age < -2 SD of the WHO Child Growth Standards median
- **Wasting**: Weight-for-height < -2 SD of the WHO Child Growth Standards median
- **Overweight**: Weight-for-height > +2 SD of the WHO Child Growth Standards median
- **Underweight**: Weight-for-age < -2 SD of the WHO Child Growth Standards median

These standardized measurements help healthcare professionals diagnose malnutrition conditions and track progress in treatment.
      ''',
      'icon': Icons.rule_outlined,
      'color': Colors.teal,
    },
    {
      'title': 'Causes of malnutrition',
      'content': '''
The most common causes of hunger and malnutrition include poverty, wars and natural disasters. The latter are exacerbated by climate change, contributing to the loss of crops, livestock or income opportunities due to extreme weather events such as droughts or floods, and leaving them without food.

The risk of malnutrition already starts in the womb. The mother's nutritional status has a significant influence on the development of the unborn child. Malnutrition during pregnancy usually results in children being born underweight and with a weakened immune system. The affected children are therefore more at risk of dying in infancy. The effects of early malnutrition are also noticeable later in life - these children are often delayed in their development and more susceptible to illness.
      ''',
      'icon': Icons.help_outline,
      'color': Colors.indigo,
    },
    {
      'title': 'Health consequences',
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

While well-nourished children have enough energy to grow, play and learn, undernourished children are usually too small and too light for their age or size. The effects can be seen in various symptoms: they are often weak, tired and lethargic. In many cases, the stunting or wasting of children leads to delayed mental development and even cognitive disability.

Undernutrition is also noticeable in children in the form of physical wasting due to a lack of fat, protein, vitamins, trace elements and minerals. This is also accompanied by a weakening of the immune system, which makes the child more vulnerable to infectious diseases such as tuberculosis. In addition to the risk of illness, there is also an increased risk of mortality.
      ''',
      'icon': Icons.warning_rounded,
      'color': Colors.blue,
    },
    {
      'title': 'Management and Treatment',
      'content': '''
**Undernutrition Treatment**
Undernutrition is treated with nutritional supplements. This might mean individual micronutrients, or it might mean refeeding with a custom, high-calorie nutritional formula designed to restore everything your body is missing. Severe undernutrition can take weeks of refeeding to correct. But refeeding can be dangerous, especially in the first few days. Your body changes in many ways to adapt to undernutrition. Refeeding asks it to change back to its old way of operating, and sometimes that change is more than it's prepared to handle. It's best to begin refeeding under close medical observation to prevent and manage the complications of refeeding syndrome, which can be serious and even life-threatening.

**Overnutrition Treatment**
Overnutrition is generally treated with weight loss, diet and lifestyle changes. Losing extra weight can help reduce your risk of developing secondary conditions such as diabetes and heart disease. Weight loss treatment may include diet and exercise plans, medications or medical procedures. You may also need to treat an underlying condition, such as thyroid disease, or a mental health disorder. Weight loss can be rapid or it can be long and gradual, depending on the path you take. But after you lose weight, it's the lifestyle changes you stick with that will help keep it off. This may involve long-term support systems such as counseling, behavioral therapy, support groups and education in nutrition.
      ''',
      'icon': Icons.healing,
      'color': Colors.green,
    },
    {
      'title': 'Prevention',
      'content': '''
Malnutrition is a global problem. In both the developed world and the developing world, poverty and a lack of understanding of nutrition are the leading causes. We can help control the disease of malnutrition with better worldwide education and support for the disadvantaged, including access to clean water, nutritious whole foods and medicine. Children and elders who may not be able to advocate for themselves are especially at risk and may need closer attention paid to their diet and health condition.

The best way to prevent malnutrition is to eat a well-balanced diet with a variety of nutritious whole foods in it. If you have enough of all the nutrients your body needs, you will be less likely to overeat trying to satisfy those needs. Some micronutrient deficiencies are common even with a fairly standard diet. A blood test is one way to find out if you could benefit from micronutrient supplements. Your healthcare provider can help you determine the correct dose to take.
      ''',
      'icon': Icons.health_and_safety,
      'color': Colors.amber,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text(
              "Malnutrition Insight",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: infoSections.length,
                itemBuilder: (context, index) {
                  final section = infoSections[index];
                  return GestureDetector(
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
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: section['color'],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              section['icon'],
                              size: 48,
                              color: Colors.white,
                            ),
                            SizedBox(height: 12),
                            Text(
                              section['title']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // Already on Insights page
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
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

// Keep these utility functions outside the StatefulWidget class
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
