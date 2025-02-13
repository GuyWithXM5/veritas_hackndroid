import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:veritasapp/Widgets/Dabba.dart';
import 'package:veritasapp/Widgets/search.dart';
import 'package:veritasapp/Widgets/toplawyers.dart';

class cldashboard extends StatelessWidget {
  const cldashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final double varHeight = MediaQuery.of(context).size.height;
    final double varWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(132, 189, 255, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: varHeight * 0.05),
            SearchButton(),
            SizedBox(height: varHeight*0.05,),
            AutoScrollDashboard(),
            SizedBox(height: varHeight * 0.05),
            DashboardBox(boxColor: Colors.white, imagePath: "assets/images/Judge-rafiki 1.svg", textColor: Colors.black, text: "New Case", height: varHeight*0.2,),
            SizedBox(height: varHeight * 0.05),
            DashboardBox(boxColor: Colors.white, imagePath: "assets/images/Judge-rafiki 1.svg", textColor: Colors.black, text: "Case\nStatus", height: varHeight*0.2,),
            SizedBox(height: varHeight * 0.05),
            DashboardBox(boxColor: Colors.white, imagePath: "assets/images/Judge-rafiki 1.svg", textColor: Colors.black, text: "Case\nStatus", height: varHeight*0.2,),
            
          ],
        ),
      ),
    );
  }
}
