import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultListPage extends StatefulWidget {
  @override
  _ResultListPageState createState() => _ResultListPageState();
}

class _ResultListPageState extends State<ResultListPage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

  Future<void> _confirmDelete(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Delete Record"),
            content: Text("Are you sure you want to delete this record?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('malnutrition_records')
          .doc(docId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Malnutrition Records"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('malnutrition_records')
                .where('userId', isEqualTo: user!.uid)
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching records"));
          }
          final records = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final result = record['result'];
              final docId = record.id;

              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(16),
                    width: double.infinity, // Fixed width
                    decoration: BoxDecoration(
                      color:
                          result.contains("📉") || result.contains("⚠️")
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            result.contains("📉") || result.contains("⚠️")
                                ? Colors.red
                                : Colors.green,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (result.contains("📉") || result.contains("⚠️")
                                  ? Colors.red
                                  : Colors.green)
                              .withOpacity(0.4),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            result.contains("📉") || result.contains("⚠️")
                                ? Colors.red[900]
                                : Colors.green[900],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 16,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color:
                            result.contains("📉") || result.contains("⚠️")
                                ? Colors.red[900]
                                : Colors.green[900],
                      ),
                      onPressed: () => _confirmDelete(context, docId),
                      tooltip: 'Delete Record',
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
