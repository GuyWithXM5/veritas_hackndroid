import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardBox extends StatelessWidget {
  final Color boxColor;
  final String imagePath;
  final Color textColor;
  final String text;
  final double height;
  final double textSize;
  final Widget? child; // ✅ Optional child

  const DashboardBox({
    super.key,
    required this.boxColor,
    required this.imagePath,
    required this.textColor,
    required this.text,
    required this.height,
    required this.textSize,
    this.child,
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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imagePath.isNotEmpty)
              SvgPicture.asset(
                imagePath,
                width: varWidth * 0.2,
                height: height * 0.6,
              ),
            SizedBox(width: 10),

            // ✅ Ensures text or child doesn't break layout
            Expanded(
              child: child ??
              Text(
                text,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
