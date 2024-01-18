import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:lifelog/main/routine/widgets/routine_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  int _currentIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 13, fontWeight: FontWeight.bold);

  List<Widget> body = const [
    Text('통계', style: optionStyle),
    RoutineWidget(),
    Text('일지', style: optionStyle),
    Text('설정', style: optionStyle),
  ];

  void onNavTap(newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  void getUserInfo() async {
    final User user = await UserApi.instance.me();
    print('사용자 정보 요청 성공'
        '\n회원번호: ${user.id}'
        '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
        '\n이메일: ${user.kakaoAccount?.email}');
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
