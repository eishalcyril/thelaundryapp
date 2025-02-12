
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:laundry_app/common/snack_bar.dart';
import 'package:laundry_app/components/verify.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Box box = Hive.box('laundry');
  late TextEditingController _phoneNumberController;
  final _formKey = GlobalKey<FormState>();
  bool iconpressed = false;
  bool otpsent = false;
  @override
  void initState() {
    // TODO: implement initState
    _phoneNumberController =
        TextEditingController(text: box.get('phoneNumber'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Registered Phone Number with the\nApp is:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.shortestSide * .6,
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: AbsorbPointer(
                                    absorbing: !iconpressed,
                                    child: TextFormField(
                                      cursorErrorColor: Colors.blue[900],
                                      onChanged: (value) {
                                        setState(() {
                                          // checked = false;
                                        });

                                        _formKey.currentState!.validate();
                                      },
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'interfont'),
                                      keyboardType: TextInputType.phone,
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                            color: Colors.red,
                                          ),
                                          fillColor: Colors.grey.shade100,
                                          filled: true,
                                          prefixIcon: const Icon(
                                              CupertinoIcons.phone_solid),
                                          prefixIconColor: Colors.blue[600],
                                          labelStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'interfsont',
                                          ),
                                          prefixText: '+91 ',
                                          prefixStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 17),
                                          labelText: "Phone",
                                          hintStyle: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            fontFamily: 'interfont',
                                          ),
                                          hintText: "Enter your phone no.",
                                          focusColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 4, 59, 103),
                                                  width: 1.5)),
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF1E88E5),
                                                  width: 1.5)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      30, 136, 229, 1),
                                                  width: 1.5)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide:
                                                  const BorderSide(color: Colors.red, width: 1.5)),
                                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.red, width: 1.5))),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Phone no.cannot be empty';
                                        }
                                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                                          return 'Ph. no. should be digits(0-9)';
                                        }
                                        if (value.length != 10) {
                                          return 'Phone no. should be 10 digits';
                                        }

                                        return null;
                                      },
                                      controller: _phoneNumberController,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          (!iconpressed)
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      iconpressed = true;
                                    });
                                  },
                                  icon: Icon(Icons.edit))
                              : TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate() &&
                                        iconpressed &&
                                        _phoneNumberController.text !=
                                            box.get('phoneNumber')) {
                                      print('OTP sent');
                                      otpsent = true;
                                      iconpressed = false;
                                    } else {
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        displaySnackBar(
                                            message:
                                                'Please change your number for verification');
                                      });
                                    }
                                  },
                                  child: Text('Send OTP'))
                        ]),
                    (otpsent)
                        ? SizedBox(
                            height:
                                MediaQuery.of(context).size.shortestSide * .7,
                            child: VerifyOTP(
                                phoneNumber: _phoneNumberController.text),
                          )
                        : (iconpressed)
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    iconpressed = false;
                                    otpsent = false;
                                  });
                                },
                                child: const Text(
                                  'Cancel editing your phone?',
                                  style: TextStyle(
                                      height: .5,
                                      letterSpacing: 1,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline),
                                ))
                            : SizedBox()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
