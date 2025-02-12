import 'package:flutter/material.dart';

class LineDash extends StatefulWidget {
  const LineDash({super.key, required this.length, required this.color});
  final int length;
  final Color color;

  @override
  State<LineDash> createState() => _LineDashState();
}

class _LineDashState extends State<LineDash> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          widget.length,
          (index) => Expanded(
                child: Container(
                  color: index % 2 == 0 ? Colors.transparent : widget.color,
                  height: 0.8,
                ),
              )),
    );
  }
}
