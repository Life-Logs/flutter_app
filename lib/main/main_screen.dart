import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  // final GoogleSignInAccount user;

  const MainScreen({
    super.key,
    // required this.user,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 13, fontWeight: FontWeight.bold);

  List<Widget> body = const [
    Text('통계', style: optionStyle),
    Text('루틴', style: optionStyle),
    Text('일지', style: optionStyle),
    Text('설정', style: optionStyle),
  ];

  void onNavTap(newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebf6e1),
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black87,
        currentIndex: _currentIndex,
        onTap: onNavTap,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade500,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee_outlined),
            label: '루틴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: '일지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
