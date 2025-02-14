import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // ⭐ Import Rating Bar Package
import 'package:veritasapp/Widgets/Dabba.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Optional for SVG icons

class AutoScrollDashboard extends StatefulWidget {
  @override
  _AutoScrollDashboardState createState() => _AutoScrollDashboardState();
}

class _AutoScrollDashboardState extends State<AutoScrollDashboard> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  int _currentPage = 0;
  List<Map<String, dynamic>> _lawyers = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchLawyers();
  }

  void _fetchLawyers() async {
    try {
      QuerySnapshot snapshot = await _db.collection('lawyer').get();
      
      List<Map<String, dynamic>> lawyers = snapshot.docs.map((doc) {
        return {
          "name": doc["username"].toString(),
          "stars": double.tryParse(doc["star"].toString()) ?? 0.0, // Convert stars to double
        };
      }).toList();

      setState(() {
        _lawyers = lawyers;
        _isLoading = false;
      });

      _startAutoSwipe();
    } catch (e) {
      print("Error fetching lawyers: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startAutoSwipe() {
    _timer?.cancel(); // Prevent multiple timers
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && _lawyers.isNotEmpty) {
        _currentPage++;
        if (_currentPage >= _lawyers.length) {
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
      height: varHeight * 0.25,
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
              itemCount: _lawyers.length,
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
                      text: _lawyers[index]["name"],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _lawyers[index]["name"],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 8),

                          // ⭐ Rounded Star Rating
                          RatingBarIndicator(
                            rating: _lawyers[index]["stars"], // Display the star rating
                            itemBuilder: (context, _) => Icon(
                              Icons.star_rounded, // Rounded star icon
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 24.0,
                            direction: Axis.horizontal,
                          ),

                          // Alternative: Use Custom SVG Rounded Stars (Uncomment to use)
                          /*
                          RatingBarIndicator(
                            rating: _lawyers[index]["stars"], 
                            itemBuilder: (context, _) => SvgPicture.asset(
                              "assets/rounded_star.svg", // Use a custom SVG star icon
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 24.0,
                            direction: Axis.horizontal,
                          ),
                          */
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
