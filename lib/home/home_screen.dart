import 'package:flutter/material.dart';
import 'package:lifelog/main/main_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebf6e1),
      body: Column(
        children: [
          const SizedBox(height: 550),
          Center(
            child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xff64705B),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const MainScreen()),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff64705B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
