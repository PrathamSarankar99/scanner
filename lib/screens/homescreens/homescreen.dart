import 'package:flutter/material.dart';
import 'package:scanner/screens/homescreens/hometabs/history_tab.dart';
import 'package:scanner/screens/homescreens/hometabs/home_tab.dart';
import 'package:scanner/screens/homescreens/hometabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs;
  int currentIndex;
  @override
  void initState() {
    currentIndex = 0;
    tabs = [
      HomeTab(
        changeTab: changeTab,
      ),
      ProfileTab(
        changeTab: changeTab,
      ),
      HistoryTab(
        changeTab: changeTab,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      children: tabs,
      index: currentIndex,
    );
  }

  changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
