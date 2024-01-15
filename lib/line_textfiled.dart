import 'dart:math' as math;

import 'package:flutter/material.dart';

class LineTextField extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final int maxLines;
  final double fontSize;
  final double fontHeight;
  final ValueChanged<String>? onChanged;

  LineTextField(
      {this.fontSize = 25,
      this.fontHeight = 1.5,
      this.maxLines = 1,
      this.onChanged,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int line = 0;
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (_, constraint) {
          TextStyle style = TextStyle(fontSize: fontSize, height: fontHeight);
          return StatefulBuilder(
            builder: (_, aState) => TextField(
              controller: controller,
              maxLines: maxLines,
              style: style,
              decoration: InputDecoration(
                isCollapsed: true,
                border:
                    MyInputBorder(height: fontSize * fontHeight, line: line),
              ),
              onChanged: (str) {
                onChanged?.call(str);
                aState(
                  () {
                    TextSpan span = TextSpan(
                      text: controller.text,
                      style: style,
                    );
                    TextPainter painter = TextPainter(
                      text: span,
                      textDirection: TextDirection.ltr,
                    )..layout(
                        minWidth: constraint.minWidth,
                        maxWidth: constraint.constrainWidth(),
                      );
                    line = painter.computeLineMetrics().length;
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MyInputBorder extends InputBorder {
  final BorderRadius borderRadius;
  final double height;
  final int line;

  const MyInputBorder(
      {super.borderSide = const BorderSide(color: Colors.red, width: 1),
      this.borderRadius = BorderRadius.zero,
      required this.height,
      required this.line});

  @override
  MyInputBorder copyWith(
      {BorderSide? borderSide,
      BorderRadius? borderRadius,
      double? height,
      int? line}) {
    return MyInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      line: line ?? this.line,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.only(bottom: borderSide.width);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(Rect.fromLTWH(rect.left, rect.top, rect.width,
          math.max(0.0, rect.height - borderSide.width)));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  bool get isOutline => false;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    print(rect);
    if (borderRadius.bottomLeft != Radius.zero ||
        borderRadius.bottomRight != Radius.zero) {
      canvas.clipPath(getOuterPath(rect, textDirection: textDirection));
    }
    double maxHeight = rect.height;
    // print("height" + height.toString());
    // print(line);
    for (double i = height; i < maxHeight; i += height) {
      canvas.drawLine(
          Offset(rect.left, rect.top + i),
          Offset(rect.right, rect.top + i),
          borderSide.toPaint()
            ..color = i == height * line ? Colors.red : Colors.blue);
      // print(i.toString() + "  " + (height * line).toString());
    }
  }

  @override
  MyInputBorder scale(double t) {
    return MyInputBorder(
        borderSide: borderSide.scale(t), height: height * t, line: line);
  }
}
