import 'package:flutter/material.dart';
import 'package:lottery/res/assets_res.dart';
import 'package:lottie/lottie.dart';

import 'lottery_page.dart';

class StaticPage extends StatelessWidget {
  const StaticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LotteryPage()),
                (route) => false);
          },
          child: Lottie.asset(
            AssetsRes.STATIC,
            width: 400,
            height: 400,
            fit: BoxFit.cover,
          )
        ),
      ),
    );
  }
}
