import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottery/line_textfiled.dart';
import 'package:lottery/random_util.dart';

import 'mmkv_util.dart';

class RectPage extends StatefulWidget {
  final VoidCallback changePage;

  const RectPage({required this.changePage, super.key});

  @override
  State<RectPage> createState() => _RectPageState();
}

class _RectPageState extends State<RectPage> {
  late List<String> list;

  @override
  void initState() {
    super.initState();
    var str = MMKVUtil.getString("rect");
    if (str.isNotEmpty) {
      list = str.split("\n");
    } else {
      list = List.generate(10, (index) => "${index + 1}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.change_circle_outlined),
          onPressed: widget.changePage,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var str = await showDialog(
                  context: context,
                  builder: (_) => const Dialog(child: _SettingDialog()));
              if (str != null) {
                MMKVUtil.put("rect", str);
                setState(() {
                  list = str.split("\n");
                });
              }
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: _RandomRect(key: ValueKey(list), list: list),
    );
  }
}

class _SettingDialog extends StatefulWidget {
  const _SettingDialog({super.key});

  @override
  State<_SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<_SettingDialog> {
  var str = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LineTextField(
            fontSize: 15,
            fontHeight: 2.5,
            maxLines: 10,
            onChanged: (value) {
              str = value;
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, str);
            },
            child: const Text("CONFIRM"),
          )
        ],
      ),
    );
  }
}

class _RandomRect extends StatefulWidget {
  final List<String> list;

  const _RandomRect({required this.list, super.key});

  @override
  State<_RandomRect> createState() => _RandomRectState();
}

class _RandomRectState extends State<_RandomRect> {
  late int length = widget.list.length;
  int select = -1;

  random() {
    var randomTimer =
        Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      setState(() {
        select = RandomUtil.randomInt(1, length);
      });
    });

    Future.delayed(const Duration(milliseconds: 5000), () {
      randomTimer.cancel();
      var stopTimer =
          Timer.periodic(const Duration(milliseconds: 300), (Timer t) {
        setState(() {
          select = RandomUtil.randomInt(1, length);
        });
      });
      Future.delayed(const Duration(milliseconds: 3000), () {
        stopTimer.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          length,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple[200]!),
                borderRadius: BorderRadius.circular(10),
                color: select == index
                    ? Colors.deepPurple[300]
                    : Colors.deepPurple[100],
              ),
              child: FittedBox(
                child: Text(widget.list[index]),
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              random();
            },
            child: const Text(
              "PRESS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
