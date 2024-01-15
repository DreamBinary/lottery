import 'package:flutter/material.dart';
import 'package:lottery/rect_page.dart';

import 'num_page.dart';

class LotteryPage extends StatefulWidget {
  const LotteryPage({super.key});

  @override
  State<LotteryPage> createState() => _LotteryPageState();
}

class _LotteryPageState extends State<LotteryPage> {
  var isNum = true;

  @override
  Widget build(BuildContext context) {
    if (isNum) {
      return NumPage(
        changePage: () {
          setState(() {
            isNum = !isNum;
          });
        },
      );
    } else {
      return RectPage(changePage: () {
        setState(() {
          isNum = !isNum;
        });
      });
    }
  }
}
