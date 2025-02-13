import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardBox extends StatelessWidget {
  final Color boxColor;
  final String imagePath;
  final Color textColor;
  final String text;
  final double height;

  const DashboardBox({super.key,
    required this.boxColor,
    required this.imagePath,
    required this.textColor,
    required this.text,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double varWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: height,
        width: varWidth * 0.9,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            SvgPicture.asset(
              alignment: Alignment.centerRight,
              imagePath,
              width: varWidth * 0.3,
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
