import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavigationDabba extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  final Color backgroundColor;
  final Color buttonColor;
  final List<IconData> icons;

  const BottomNavigationDabba({
    super.key,
    required this.index,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.buttonColor = Colors.blue,
    this.icons = const [
      Icons.home,
      Icons.file_present,
      Icons.payment,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: CurvedNavigationBar(
        index: index,
        backgroundColor: backgroundColor,
        color: buttonColor,
        animationDuration: Duration(milliseconds: 300),
        onTap: onTap,
        items: icons.map((icon) => Icon(icon, color: Colors.white)).toList(),
      ),
    );
  }
}
