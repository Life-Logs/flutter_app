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
              child: Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => signIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    'Login with Google',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

// google login 창
  // Future signIn(context) async {
  // final user = await GoogleSignInApi.login();

  // if (user == null) {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text('Sign in Failed')));
  // } else {
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
  //     builder: (context) => MainScreen(user: user),
  //   ));
  // }
  // }

// google login api
  // void signIn(BuildContext context) {
  //   ApiService.getId().then((response) {
  //     if (response.statusCode == 200) {
  //       String cookies = response.headers['set-cookie'];
  //     } else {
  //       print('Request failed with status: ${response.statusCode}');
  //     }
  //   }).catchError((error) {
  //     print('Error: $error');
  //   });
  // }

  // 로그인 인증 없이 로그인
  void signIn(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MainScreen()));
  }
}
