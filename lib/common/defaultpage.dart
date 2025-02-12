import 'package:flutter/material.dart';
import 'package:laundry_app/common/app_bar.dart';
import 'package:laundry_app/common/widgets.dart';

class Default extends StatelessWidget {
  const Default({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: Text('')),

      //  body: StripesPayment(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: borderCard(
          builder: const Center(
            child: Text(
              'This Feature is Under Development,\n please try again later',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
