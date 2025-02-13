import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:veritasapp/hero_dialog_route.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final double varWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 360,
            height: 100,
            child: SizedBox(
              height: 60,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(200),
                      borderSide: BorderSide.none),
                  prefixIcon: Icon(Icons.search_sharp),
                  hintText: ("Search for Advocates"),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ),
          Positioned(
            left: 285,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                  return const _PopupCard();
                }));
              },
              child: Hero(
                tag: "profile",
                child: SvgPicture.asset(
                  "assets/images/man-user-circle-icon 1.svg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopupCard extends StatelessWidget {
  const _PopupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Hero(
          tag: "profile",
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/images/man-user-circle-icon 1.svg",
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  TextButton(onPressed: () {}, child: Text("Profile")),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/loginclient", (route) => false);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text("Logged out")));
                      },
                      child: Text("Log out")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}