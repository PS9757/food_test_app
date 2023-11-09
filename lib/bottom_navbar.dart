import 'dart:ui';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app_ass/src/presentation/views/Bookmark/bookmarkscreen.dart';
import 'package:food_app_ass/src/presentation/views/Stream/streamScreen.dart';
import 'package:food_app_ass/src/presentation/views/home/home.dart';
import 'package:food_app_ass/src/presentation/views/profile/profile.dart';
import 'package:food_app_ass/src/presentation/widget/location_widget.dart';

class MyCustomBottomNavigationBar extends StatefulWidget {
  @override
  MyCustomBottomNavigationBarState createState() =>
      MyCustomBottomNavigationBarState();
}

class MyCustomBottomNavigationBarState
    extends State<MyCustomBottomNavigationBar> {
  var currentIndex = 0;
  var isScan = false;
  final List<Widget> screens = [
    HomeScreen(),
    StreamScreen(),
    BookMarkScreen(),
    ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 225, 225, 1),
      body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            backgroundColor: Colors.deepPurple,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 20, left: 50, right: 50),
            content: Text(
              'Tap back again to leave',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          child: screens[currentIndex]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isScan = true;
          });
        },
        backgroundColor: Colors.red,
        shape: const CircleBorder(),
        child: SvgPicture.asset("assets/images/scan.svg"),
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        color: Colors.white,
        height: size.width * .155,
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),

          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {
                currentIndex = index;
                isScan = false;
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: size.width * .014),
                Icon(listOfIcons[index],
                    size: size.width * .076, color: currentIndex==index?Colors.red:Color(0xffD37272)),
                AnimatedContainer(
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    top: index == currentIndex ? 0 : size.width * .029,
                    right: size.width * .0422,
                    left: size.width * .0422,
                  ),
                  width: size.width * .16,
                  height: !isScan && index == currentIndex ? size.width * .045 : 0,
                  child: Center(
                    child: Text(
                      name[index],
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.live_tv,
    Icons.bookmark,
    Icons.person_rounded,
  ];
  List<String> name =[
    "Home",
    "Stream",
    "BookMark",
    "Profile",
  ];
}
