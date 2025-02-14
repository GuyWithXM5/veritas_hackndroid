import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Selectlawyer extends StatefulWidget {
  const Selectlawyer({super.key});

  @override
  State<Selectlawyer> createState() => _SelectlawyerState();
}

class _SelectlawyerState extends State<Selectlawyer> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ValueNotifier<String?> selectedLawyerId = ValueNotifier<String?>(null);

  void requestConfirmation(String lawyerId) {
    print("Request sent to lawyer with ID: $lawyerId");
    // Replace with Firestore update logic if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(132, 189, 255, 1),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection("lawyer").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No lawyers found"));
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Select a Lawyer to Proceed",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<String?>(
                  valueListenable: selectedLawyerId,
                  builder: (context, selectedId, child) {
                    return Column(
                      children: snapshot.data!.docs.map((lawyer) {
                        var lawyerData = lawyer.data() as Map<String, dynamic>;
                        String lawyerId = lawyer.id;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: ListTile(
                            title: Text(
                              lawyerData['username'] ?? 'Unknown',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(lawyerData['lawyerType'] ??
                                'No specialization'),
                            leading:
                                const CircleAvatar(child: Icon(Icons.person)),
                            trailing: Checkbox(
                              value: selectedId == lawyerId,
                              onChanged: (bool? value) {
                                selectedLawyerId.value =
                                    value == true ? lawyerId : null;

                                if (value == true) {
                                  requestConfirmation(lawyerId);
                                }
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}
