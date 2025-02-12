import 'package:flutter/material.dart';

class PatientDetailsItem extends StatelessWidget {
  const PatientDetailsItem(
      {super.key,
      required this.heading,
      required this.value,
      this.valueStyle,
      this.size = 16});

  final String heading;
  final String value;
  final TextStyle? valueStyle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return value != ''
        ? Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(heading,
                        maxLines: 5,
                        style: TextStyle(
                            fontSize: size, color: Colors.grey[700]))),
                Text(
                  ': ',
                  style: valueStyle ??
                      TextStyle(fontSize: size, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 5,
                    style: valueStyle ??
                        TextStyle(fontSize: size, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(thickness: .1),
              ],
            ),
          )
        : Container();
  }
}
