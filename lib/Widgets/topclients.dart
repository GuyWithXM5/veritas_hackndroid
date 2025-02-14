import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:veritasapp/Widgets/Dabba.dart';

class AutoScrollDashboardLaw extends StatefulWidget {
  @override
  _AutoScrollDashboardStateLaw createState() => _AutoScrollDashboardStateLaw();
}

class _AutoScrollDashboardStateLaw extends State<AutoScrollDashboardLaw> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  int _currentPage = 0;
  List<String> _caseBriefings = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchCaseBriefings();
  }

  void _fetchCaseBriefings() async {
    try {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot clientsSnapshot =
          await _db.collection("hehe").get();
      List<String> caseBriefings = [];

      if (clientsSnapshot.docs.isEmpty) {
        print("No clients found in Registered_Cases.");
      }

      for (var clientDoc in clientsSnapshot.docs) {
        String clientId = clientDoc.id;
        print("hello");
        print(clientId);
        QuerySnapshot casesSnapshot = await _db
            .collection("hehe")
            .doc(clientId)
            .collection('cases')
            .get();

        if (casesSnapshot.docs.isEmpty) {
          print("No cases found for client: $clientId");
        }

        for (var caseDoc in casesSnapshot.docs) {
          final caseData = caseDoc.data() as Map<String, dynamic>;
          if (caseData.containsKey('briefing')) {
            caseBriefings.add(caseData['briefing'].toString());
          } else {
            print("Missing 'briefing' field in case: ${caseDoc.id}");
          }
        }
      }

      if (caseBriefings.isEmpty) {
        caseBriefings.add("No cases available");
      }

      setState(() {
        _caseBriefings = caseBriefings;
        _isLoading = false;
      });

      print("Fetched Case Briefings: $_caseBriefings");

      _startAutoSwipe(); // Start auto-scroll only after loading data
    } catch (e) {
      print("Error fetching case briefings: $e");
      setState(() {
        _isLoading = false;
        _caseBriefings = ["Error loading cases"];
      });
    }
  }

  void _startAutoSwipe() {
    _timer?.cancel(); // Prevent multiple timers
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && _caseBriefings.isNotEmpty) {
        _currentPage++;
        if (_currentPage >= _caseBriefings.length) {
          _currentPage = 0; // Reset to first page
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: varHeight * 0.2,
      child: _isLoading
          ? Center(
              child: DashboardBox(
                textSize: 12,
                boxColor: Colors.black,
                imagePath: "",
                textColor: Colors.white,
                text: "Loading...",
                height: varHeight * 0.3,
              ),
            )
          : PageView.builder(
              controller: _pageController,
              itemCount: _caseBriefings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: varWidth * 0.025),
                  child: Center(
                    child: DashboardBox(
                      textSize: 15,
                      boxColor: Colors.black,
                      imagePath: "",
                      textColor: Colors.white,
                      height: varHeight * 0.3,
                      text: _caseBriefings[index],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
