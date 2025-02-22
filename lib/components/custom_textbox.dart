import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox(
      {super.key,
      this.hint = '',
      this.prefix,
      this.suffix,
      this.controller,
      this.color = Colors.green});
  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 3),
      height: 44,
      decoration: BoxDecoration(
          // color: textBoxColor,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: InputBorder.none,
          hintText: hint,
          // hintStyle: TextStyle(color: darker, fontSize: 15)
        ),
      ),
    );
  }
}
