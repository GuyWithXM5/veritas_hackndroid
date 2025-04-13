import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veritasapp/Widgets/bottomnavigation.dart';

class Casestatus extends StatefulWidget {
  const Casestatus({super.key});

  @override
  State<Casestatus> createState() => _CaseStatusState();
}

class _CaseStatusState extends State<Casestatus> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _deleteCase(String caseId) async {
    try {
      await _db
          .collection("regcase")
          .doc(_firebaseAuth.currentUser!.uid)
          .collection("Cases")
          .doc(caseId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Case deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete(String caseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Case"),
        content: const Text("Are you sure you want to delete this case?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCase(caseId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(132, 189, 255, 1),
      appBar: AppBar(
        title: const Text(
          "Your Case Status",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(132, 189, 255, 1),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection("regcase")
            .doc(_firebaseAuth.currentUser!.uid)
            .collection("Cases")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.black)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Cases Found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var caseDoc = snapshot.data!.docs[index];
              var caseData = caseDoc.data() as Map<String, dynamic>;

              return Card(
                color: Colors.white,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Case Title
                      Text(
                        caseData['caseType'] ?? 'Untitled Case',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 6),

                      // Case Description
                      Text(
                        caseData['briefing'] ?? 'No description provided.',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 10),

                      // Status Badge & Delete Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: caseData['status'] == 'Pending'
                                  ? Colors.orange
                                  : caseData['status'] == 'Approved'
                                      ? Colors.green
                                      : Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              caseData['status'] ?? 'Pending',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () => _confirmDelete(caseDoc.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationDabba(
        index: 0,
        onTap: (index) {
          // print("Selected Index: $index");
          if (index == 0) {
            Navigator.pushNamed(context, "/cldashboard");
          }
        },
        backgroundColor: Colors.grey[200]!,
        buttonColor: Colors.black,
        icons: [Icons.home, Icons.file_copy, Icons.payment],
      ),
    );
  }
}
