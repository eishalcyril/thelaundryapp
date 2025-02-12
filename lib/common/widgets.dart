import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:laundry_app/config.dart';
import 'package:shimmer/shimmer.dart';

class WaveLoading extends StatelessWidget {
  const WaveLoading({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: SpinKitWave(size: 25, color: Theme.of(context).primaryColor),
      );
}

class HeadCard extends StatefulWidget {
  const HeadCard({
    super.key,
    this.color,
    this.title,
    this.width,
    this.textColor = Colors.white,
    this.elavation = 8,
    this.textStyle,
  });

  final String? title;
  final double? width;
  final Color? color;
  final Color? textColor;
  final double? elavation;
  final TextStyle? textStyle;

  @override
  HeadCardState createState() => HeadCardState();
}

class HeadCardState extends State<HeadCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: widget.elavation,
      color: widget.color ?? primaryShade,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: widget.width ?? double.infinity,
          child: Text(
            widget.title.toString(),
            style: widget.textStyle ??
                TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

Future? newtworkExceptionDialog(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      title: const Text('Network error'),
      content: const Text(
        'Something is temporarily wrong with your network connection. Please make sure you are connected to the internet',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
  return null;
}

Widget borderCard({
  @required Widget? builder,
  Color borderColor = const Color.fromRGBO(198, 40, 40, 1),
  double borderWidth = 2.0,
  double elavation = 2.0,
  String heading = '',
  Color headingBgcolor = Colors.white,
}) {
  return Stack(
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 3,
          ),
          Card(
            elevation: elavation,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: builder,
            ),
          ),
        ],
      ),
      if (heading != '')
        Align(
            alignment: const Alignment(-0.85, 10),
            child: Container(
                color: headingBgcolor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(heading),
                ))),
    ],
  );
}

Future logoutAlertD(BuildContext context) {
  const OutlinedBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  );
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: shape,
        backgroundColor: Colors.grey[100],
        elevation: 3.0,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Alert!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
              child: Text(
                'Do you really want to logout?',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: shape),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(220, 20, 60, .9),
                    shape: shape,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (Route route) => false);
                    // context.read<UserCubit>().logout();
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future alertD({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonText1,
  required String buttonText2,
  bool barrierRestriction = false,
  ButtonStyle? buttonStyle1,
  ButtonStyle? buttonStyle2,
  String? errorText,
  required Function() fn1,
  required Function() fn2,
}) {
  const OutlinedBorder shape = RoundedRectangleBorder(
    side: BorderSide(width: 1.0, color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
  return showDialog(
    barrierDismissible: barrierRestriction,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: shape,
        backgroundColor: Colors.grey[100],
        elevation: 3.0,
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
              child: Column(
                children: [
                  Text(
                    content,
                  ),
                  if (errorText != null && errorText.isNotEmpty)
                    Text(
                      errorText,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: buttonStyle1 ??
                      ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      ),
                  onPressed: fn1,
                  child: Text(buttonText1),
                ),
                ElevatedButton(
                  style: buttonStyle2 ??
                      ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(220, 20, 60, .9),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      ),
                  onPressed: fn2,
                  child: Text(
                    buttonText2,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future notifyD({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonText1,
  ButtonStyle? buttonStyle1,
  bool barrierRestriction = false,
  required Function() fn1,
}) {
  const OutlinedBorder shape = RoundedRectangleBorder(
    side: BorderSide(width: 1.0, color: Colors.black),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  );
  return showDialog(
    barrierDismissible: barrierRestriction,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: shape,
        backgroundColor: Colors.grey[100],
        elevation: 3.0,
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
              child: Text(
                content,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: buttonStyle1 ??
                      ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                      ),
                  onPressed: fn1,
                  child: Text(buttonText1),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget listItem({
  Widget? builder,
  String? leading = '\u2022',
  String? content = '',
  TextStyle? leadingStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  TextStyle? contentStyle = const TextStyle(),
}) {
  // ignore: parameter_assignments
  builder = builder ??
      Text(
        content!,
        textAlign: TextAlign.justify,
        style: contentStyle,
        //textscaleFactor: 1,
      );
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              leading!,
              style: leadingStyle,
            ),
          ),
        ),
        Flexible(flex: 9, fit: FlexFit.tight, child: builder),
      ],
    ),
  );
}

void displayBottomSheet({
  required BuildContext? context,
  Widget? builder,
  Color? backgroundColor,
  int? height = 50,
  double? hPadding = 2.0,
  double? vPadding = 0.0,
  BorderRadiusGeometry? borderRadius = const BorderRadius.vertical(
    top: Radius.circular(30),
  ),
  int transparency = 1,
}) {
  final double padding =
      MediaQueryData.fromView(WidgetsBinding.instance.window).padding.top;
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context!,
      barrierColor: Colors.black.withAlpha(transparency),
      backgroundColor: const Color.fromARGB(0, 247, 153, 153),
      builder: (context) => Padding(
        padding:
            EdgeInsets.symmetric(horizontal: hPadding!, vertical: vPadding!),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.black.withAlpha(1),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, -1),
                  blurRadius: 50,
                ),
              ],
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - padding,
            ),
            height: MediaQuery.of(context).size.height * (height! / 150) +
                MediaQuery.of(context).viewInsets.bottom,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.black.withAlpha(1),
              body: Card(
                elevation: 0,
                // color: backgroundColor ?? primaryShadeLight.shade50,
                color: backgroundColor ?? Colors.white,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius,
                ),
                child: builder,
              ),
            ),
          ),
        ),
      ),
    );
  });
}

Widget shimmerList({
  int itemcount = 5,
  bool heading = false,
  int contentHeight = 100,
  bool isRandomHeight = true,
  double padding = 8,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
    child: ListView.builder(
      itemBuilder: (_, index) {
        final Random random = Random();
        final int randomNumber = random.nextInt(15);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: <Widget>[
                heading
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 30.0,
                          color: Colors.grey,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: padding,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: contentHeight +
                        10.0 * randomNumber * (isRandomHeight ? 1 : 0),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: itemcount,
    ),
  );
}

Widget submitButton({
  required title,
  required VoidCallback? onPressed,
}) {
  return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: onPressed != null
            ? WidgetStateProperty.all<Color>(const Color(0xFF064789))
            : WidgetStateProperty.all<Color>(const Color(0xFFCCCCCC)),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Adjust the border radius as needed
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ));
}

Widget indicatorCheckBox(
    Map document, Map<String, bool> result, Map response, bool isWhite) {
  return Container(
    // color: isWhite ? Colors.white : Colors.grey[100],
    color: Colors.transparent,
    child: Row(
      children: [
        const SizedBox(width: 10),
        (document['color'] == 'Nill')
            ? const SizedBox()
            : Icon(Icons.circle, color: document['color'] as Color, size: 10),
        const SizedBox(width: 10),
        Expanded(
          child: FormBuilderCheckbox(
            controlAffinity: ListTileControlAffinity.trailing,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide.none), // Add this line to disable the border
            ),
            name: document[
                'patientTriageIndicatorProperty_patientStageSettings_Text'],
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              document[
                  'patientTriageIndicatorDisplayName_patientStageSettings_Text'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Poppins',
                height: 1.2,
              ),
            ),
            onChanged: (value) {
              result[document[
                      'patientTriageIndicatorProperty_patientStageSettings_Text']] =
                  value ?? false;
            },
            onSaved: (value) {
              result[document[
                      'patientTriageIndicatorProperty_patientStageSettings_Text']] =
                  value ?? false;
            },
            initialValue: response[document[
                    'patientTriageIndicatorProperty_patientStageSettings_Text']] ??
                false,
          ),
        ),
      ],
    ),
  );
}

Widget rowText(String title, Color colortype) {
  return Row(
    children: [
      Icon(Icons.circle, color: colortype, size: 10),
      const SizedBox(
        width: 5,
      ),
      Text(title)
    ],
  );
}

Widget serviceUnavailable(
  BuildContext context,
  final String title,
  final String content,
  final Color containerColor,
  final Color themeColor,
) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: themeColor),
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: themeColor, size: 50),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: themeColor),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 2,
                      color: themeColor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
