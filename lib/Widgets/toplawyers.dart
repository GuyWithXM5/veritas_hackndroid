import 'package:flutter/material.dart';
import 'dart:async';


import 'package:veritasapp/Widgets/Dabba.dart'; 

class AutoScrollDashboard extends StatefulWidget {
  @override
  _AutoScrollDashboardState createState() => _AutoScrollDashboardState();
}

class _AutoScrollDashboardState extends State<AutoScrollDashboard> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSwipe();
  }

  void _startAutoSwipe() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= 10) {
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
      child: PageView.builder(
        controller: _pageController,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: varWidth * 0.025), // Adding gap between items
            child: Center(
              child: DashboardBox(
                boxColor: Colors.black,
                imagePath: "", // Use your image path here
                textColor: Colors.white,
                text: "Lawyer $index",
                height: varHeight * 0.3,

              ),
            ),
          );
        },
      ),
    );
  }
}
