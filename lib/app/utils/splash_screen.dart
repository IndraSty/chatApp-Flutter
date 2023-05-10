import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  "assets/icon/chat.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 94,
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xff515151),
      ),
    );
  }
}
