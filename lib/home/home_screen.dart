import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:lifelog/main/main_screen.dart';
import 'package:lifelog/services/api_services.dart';
import 'package:lifelog/services/auth_store.dart';

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
                    backgroundColor: const Color(0xffFEE500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Login with Kakao',
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

  void signIn(BuildContext context) async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        TokenStorage tokenStorage = TokenStorage();
        String accessToken = token.accessToken;

        Map<String, dynamic> data = {'accessToken': accessToken};
        final response = await ApiService.kakaoLogin(data);
        print(response);
        Map<String, dynamic> parsedJson = json.decode(response.body);

        String myAccessToken = parsedJson['accessToken'];
        tokenStorage.saveToken(myAccessToken);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ));

        print('$token 카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          TokenStorage tokenStorage = TokenStorage();
          String accessToken = token.accessToken;

          Map<String, dynamic> data = {'accessToken': accessToken};
          final response = await ApiService.kakaoLogin(data);
          print(response);
          Map<String, dynamic> parsedJson = json.decode(response.body);

          String myAccessToken = parsedJson['accessToken'];
          tokenStorage.saveToken(myAccessToken);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ));
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        TokenStorage tokenStorage = TokenStorage();
        String accessToken = token.accessToken;

        Map<String, dynamic> data = {'accessToken': accessToken};
        final response = await ApiService.kakaoLogin(data);
        print(response.body);
        Map<String, dynamic> parsedJson = json.decode(response.body);

        String myAccessToken = parsedJson['accessToken'];
        tokenStorage.saveToken(myAccessToken);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ));
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }
}
