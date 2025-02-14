import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';


import 'package:veritasapp/Widgets/Dabba.dart'; 

class AutoScrollDashboard extends StatefulWidget {
  @override
  _AutoScrollDashboardState createState() => _AutoScrollDashboardState();
}

class _AutoScrollDashboardState extends State<AutoScrollDashboard> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  int _currentPage = 0;
  List<String> _lawyerNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLawyers();
    _startAutoSwipe();
  }

  void _fetchLawyers() async {
    try {
      QuerySnapshot snapshot = await _db.collection('lawyer').get();
      setState(() {
        _lawyerNames = snapshot.docs.map((doc) => doc['username'].toString()).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching lawyers: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startAutoSwipe() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && _lawyerNames.isNotEmpty) {
        _currentPage++;
        if (_currentPage >= _lawyerNames.length) {
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
                imagePath: "", // Use your image path here
                textColor: Colors.white,
                text: "Loading...",
                height: varHeight * 0.3,
              ),
            )
          : PageView.builder(
              controller: _pageController,
              itemCount: _lawyerNames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: varWidth * 0.025),
                  child: Center(
                    child: DashboardBox(
                      textSize: 15,
                      boxColor: Colors.black,
                      imagePath: "", // Use your image path here
                      textColor: Colors.white,
                      height: varHeight * 0.3,
                      text: _lawyerNames[index], // Pass the lawyer name here
                    ),
                  ),
                );
              },
            ),
    );
  }
}
