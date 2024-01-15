import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottery/random_util.dart';

class NumPage extends StatefulWidget {
  final VoidCallback changePage;

  const NumPage({required this.changePage, super.key});

  @override
  State<NumPage> createState() => _NumPageState();
}

class _NumPageState extends State<NumPage> {
  int cnt = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.change_circle_outlined),
          onPressed: widget.changePage,
        ),
        actions: [
          Text("$cnt"),
          Slider(
            value: cnt.toDouble(),
            min: 1,
            max: 100,
            divisions: 99,
            onChanged: (value) {
              setState(() {
                cnt = value.toInt();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: _RandomItem(
            key: ValueKey(cnt), list: List.generate(cnt, (index) => index + 1)),
      ),
    );
  }
}

class _RandomItem extends StatefulWidget {
  final List list;

  const _RandomItem({super.key, required this.list});

  @override
  State<_RandomItem> createState() => _RandomItemState();
}

class _RandomItemState extends State<_RandomItem> {
  late var cnt = RandomUtil.randomOne(widget.list);
  Timer? randomTimer;

  Timer? stopTimer;

  late List list = widget.list;

  cancel() {
    if (randomTimer != null && randomTimer!.isActive) {
      randomTimer?.cancel();
    }
    if (stopTimer != null && stopTimer!.isActive) {
      stopTimer?.cancel();
    }
  }

  start() {
    cancel();
    randomTimer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      setState(() {
        cnt = RandomUtil.randomOne(list);
      });
    });
  }

  end() {
    cancel();
    stopTimer = Timer.periodic(const Duration(milliseconds: 400), (Timer t) {
      setState(() {
        cnt = RandomUtil.randomOne(list);
      });
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      stopTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _RandomDisplay(cnt: cnt),
        const SizedBox(height: 50),
        _RandomButton(
          start: (t) {
            start();
          },
          end: (t) {
            end();
          },
        ),
      ],
    );
  }
}

class _RandomButton extends StatefulWidget {
  final GestureDragStartCallback start;
  final GestureDragEndCallback end;

  const _RandomButton({required this.start, required this.end, super.key});

  @override
  State<_RandomButton> createState() => _RandomButtonState();
}

class _RandomButtonState extends State<_RandomButton> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onDoubleTap: () {
      //   widget.cancel();
      // },
      onPanStart: (t) {
        widget.start(t);
        setState(() {
          scale = 0.75;
        });
      },
      onPanEnd: (t) {
        widget.end(t);
        setState(() {
          scale = 1;
        });
      },
      child: Container(
        height: 150,
        width: 150,
        transform: Matrix4.identity()..scale(scale, scale),
        transformAlignment: Alignment.center,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.deepPurple[100],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(30),
        child: const FittedBox(
          child: Text(
            "PRESS",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _RandomDisplay extends StatelessWidget {
  final dynamic cnt;

  const _RandomDisplay({required this.cnt, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(50),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 50),
        child: FittedBox(
          key: ValueKey(cnt),
          child: Text(
            '$cnt',
            style: const TextStyle(
              fontSize: 150,
              fontWeight: FontWeight.bold,
              color: Color(0xff232323),
            ),
          ),
        ),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation.drive(
              Tween(begin: 0.75, end: 1.0).chain(
                CurveTween(curve: Curves.easeInOutSine),
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
