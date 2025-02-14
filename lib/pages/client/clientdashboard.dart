import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:veritasapp/Widgets/Dabba.dart';
import 'package:veritasapp/Widgets/search.dart';
import 'package:veritasapp/Widgets/toplawyers.dart';
import 'package:veritasapp/Widgets/bottomnavigation.dart';
// import 'package:veritasapp/pages/chatscreen.dart';
// import 'package:veritasapp/pages/client/registercase.dart';

class cldashboard extends StatelessWidget {
  const cldashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final double varHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(132, 189, 255, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: varHeight * 0.05),
            SearchButton(),
            SizedBox(
              height: varHeight * 0.05,
            ),
            AutoScrollDashboard(),
            SizedBox(height: varHeight * 0.05),
            GestureDetector(
              child: DashboardBox(
                textSize: 24,
                boxColor: Colors.white,
                imagePath: "assets/images/Judge-rafiki 1.svg",
                textColor: Colors.black,
                text: "New Case",
                height: varHeight * 0.2,
              ),
              onTap: () {
                Navigator.pushNamed(context, "/regcase");
              },
            ),
            SizedBox(height: varHeight * 0.05),
            GestureDetector(
              child: DashboardBox(
                textSize: 24,
                boxColor: Colors.white,
                imagePath: "assets/images/Judge-rafiki 1.svg",
                textColor: Colors.black,
                text: "Case\nStatus",
                height: varHeight * 0.2,
              ),
              onTap: () {
                Navigator.pushNamed(context, "/casestatus");
              },
            ),
            SizedBox(height: varHeight * 0.05),
            DashboardBox(
              textSize: 24,
              boxColor: Colors.white,
              imagePath: "assets/images/Judge-rafiki 1.svg",
              textColor: Colors.black,
              text: "Case\nStatus",
              height: varHeight * 0.2,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationDabba(
        index: 0,
        onTap: (index) {
          print("Selected Index: $index");
        },
        backgroundColor: Colors.grey[200]!,
        buttonColor: Colors.black,
        icons: [Icons.home, Icons.file_copy, Icons.payment],
      ),
    );
  }
}
