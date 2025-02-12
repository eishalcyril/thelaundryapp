import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final CarouselController controller = CarouselController(initialItem: 1);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        spacing: 40,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                'Revolutionizing\nLaundry\nExperience',
                speed: Duration(milliseconds: 100),
                textStyle: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              )
            ],
            isRepeatingAnimation: true,
          ),
          AnimatedTextKit(
              pause: Duration(milliseconds: 0),
              repeatForever: true,
              animatedTexts: [
                ColorizeAnimatedText("Your laundry, delivered with care.",
                    textStyle: TextStyle(
                        fontSize: 24, color: Colors.blueGrey.shade500),
                    colors: [
                      Colors.black,
                      Colors.brown.shade200,
                      Colors.black
                    ]),
              ]),
        ],
      ),
    );
  }
}
