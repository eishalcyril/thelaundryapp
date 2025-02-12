import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:laundry_app/components/first_page.dart';
import 'package:laundry_app/components/homescreens/home.dart';
import 'package:laundry_app/config.dart';
import 'package:laundry_app/usercubit/user_cubit.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';

class OnboardContent extends StatefulWidget {
  const OnboardContent({
    super.key,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });
  final String? phoneNumber;
  final String? email;
  final String? address;

  @override
  State<OnboardContent> createState() => _OnboardContentState();
}

class _OnboardContentState extends State<OnboardContent> {
  late PageController _pageController;
  Box box = Hive.box('laundry');

  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController firstname;
  late TextEditingController lastname;
  final _signinformKey = GlobalKey<FormState>();
  final _signupformKey = GlobalKey<FormState>();
  late bool isPhone;
  bool forgotPasswordBool = false;
  late bool _passwordVisible;
  late bool _newPasswordVisible;
  late bool _confirmPasswordVisible;
  late TextEditingController _passwordController;

  final TextEditingController _newPasswordController = TextEditingController();
  late TextEditingController _addressController;
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _signinpwd = TextEditingController();

  @override
  void initState() {
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _emailController = TextEditingController(text: widget.email);
    _addressController = TextEditingController(text: widget.address);
    firstname = TextEditingController(text: '');
    lastname = TextEditingController(text: '');
    isPhone = widget.phoneNumber == null ? false : true;
    _passwordVisible = true;
    _newPasswordVisible = true;
    _confirmPasswordVisible = true;
    context.read<UserCubit>().initState();
    super.initState();
    _pageController = PageController(initialPage: (isPhone) ? 1 : 0)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  void reload() {
    setState(() {
      isPhone = true;
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress =
        _pageController.hasClients ? (_pageController.page ?? 0) : 0;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .4 +
              progress *
                  ((state is LoginLoading || state is LoginError)
                      ? 20
                      : (state is UserInitial || state is LoginLoading)
                          ? 80
                          : 320),
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.blueGrey.shade100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        children: [const FirstPage(), secondForm(context)],
                      ),
                    ),
                  ],
                ),
                if (state is UserSignUp || state is UserInitial)
                  Positioned(
                    height: 46,
                    bottom: 48 + progress,
                    right: 16,
                    child: GestureDetector(
                      onTap: () async {
                        if (_pageController.page == 0) {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.ease,
                          );
                        } else {
                          // setState(()  {
                          bool isPageValid = ((state is UserInitial)
                                  ? _signinformKey.currentState?.validate()
                                  : _signupformKey.currentState?.validate()) ??
                              false;

                          if (isPageValid &&
                              _pageController.page == 1 &&
                              state is UserInitial) {
                            context.read<UserCubit>().userLogin({
                              'email': _emailController.text,
                              'password': _signinpwd.text
                            });
                            // await NewApiService().login(
                            //     email: _emailController.text,
                            //     password: _signinpwd.text);
                          } else {
                            context.read<UserCubit>().userLogin({
                              'firstName': firstname,
                              'lastName': lastname,
                              'email': _emailController.text,
                              'address': _addressController.text,
                              'phoneNumber': _phoneNumberController.text,
                              'password': _newPasswordController.text
                            });
                          }
                          // });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0.15, 0.9],
                            colors: [
                              Color.fromRGBO(196, 101, 58, 1),
                              Color.fromRGBO(179, 45, 0, 0.792),
                            ],
                          ),
                        ),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 92 - progress * 15,
                                child: Stack(
                                  fit: StackFit.passthrough,
                                  children: [
                                    FadeTransition(
                                      opacity:
                                          AlwaysStoppedAnimation(1 - progress),
                                      child: const Center(
                                          child: Text("Get Started")),
                                    ),
                                    FadeTransition(
                                      opacity: AlwaysStoppedAnimation(progress),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.65,
                                        child: (state is UserInitial)
                                            ? const Center(
                                                child: Text(
                                                  "Login",
                                                  style: TextStyle(
                                                    // color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              )
                                            : const Center(
                                                child: Text(
                                                  "Register",
                                                  style: TextStyle(
                                                    // color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 24,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget secondForm(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserInitial) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          textAlign: TextAlign.center,
                          "You're all set, please signin",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _signinformKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // const SizedBox(
                            //   height: 45,
                            // ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    cursorErrorColor: Colors.blue[900],
                                    onChanged: (value) {
                                      setState(() {
                                        // checked = false;
                                      });

                                      _signinformKey.currentState!.validate();
                                    },
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'interfont'),
                                    keyboardType: TextInputType.emailAddress,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _signinformKey.currentState!.validate();
                                    },
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: primaryColor,
                                        ),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        prefixIcon: isPhone
                                            ? const Icon(
                                                CupertinoIcons.mail_solid)
                                            : const Icon(CupertinoIcons.mail),
                                        prefixIconColor: Colors.blueGrey,
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfsont',
                                        ),
                                        labelText: "e-mail",
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfont',
                                        ),
                                        hintText: "Enter your Login ID.",
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
                                                color: Colors.blueGrey,
                                                width: 1.5)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 171, 18, 7),
                                                width: 1.5)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(color: Color.fromARGB(255, 171, 18, 7), width: 1.5))),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email id cannot be empty';
                                      }
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                    controller: _emailController,
                                  ),
                                  TextFormField(
                                    onChanged: (value) {
                                      _signinformKey.currentState!.validate();
                                    },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'interfont',
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      prefixIcon: const Icon(
                                          CupertinoIcons.lock_circle_fill),
                                      prefixIconColor: Colors.blueGrey,
                                      suffixIconColor: primaryColor,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _newPasswordVisible
                                              ? CupertinoIcons.eye_slash
                                              : CupertinoIcons.eye,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _newPasswordVisible =
                                                !_newPasswordVisible;
                                          });
                                        },
                                      ),
                                      labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey,
                                        fontFamily: 'interfsont',
                                      ),
                                      errorStyle: TextStyle(
                                        color: primaryColor,
                                      ),
                                      labelText: "Password",
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'interfont',
                                        fontSize: 17,
                                      ),
                                      hintText: "Enter Password",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 4, 59, 103),
                                              width: 1.5)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Colors.blueGrey,
                                              width: 1.5)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 171, 18, 7),
                                              width: 1.5)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 171, 18, 7),
                                              width: 1.5)),
                                      errorMaxLines: 3,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      if (value.length < 6 ||
                                          value.length > 32) {
                                        return 'Password must be between 6 and 32 characters';
                                      }
                                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                          .hasMatch(value)) {
                                        return 'Password must contain at least one special character';
                                      }
                                      if (!RegExp(r'[a-zA-Z]')
                                          .hasMatch(value)) {
                                        return 'Password must contain at least one letter character';
                                      }
                                      if (!RegExp(r'\d').hasMatch(value)) {
                                        return 'Password must contain at least one number';
                                      }
                                      return null;
                                    },
                                    controller: _signinpwd,
                                    obscureText: _newPasswordVisible,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        context.read<UserCubit>().signUp();
                                      },
                                      child: Text(
                                        "Not a User? Register",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: primaryColor,
                                            height: .8,
                                            fontSize: 15),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (state is UserSignUp) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          textAlign: TextAlign.center,
                          "For the first time, please register.",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _signupformKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // const SizedBox(
                            //   height: 45,
                            // ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    cursorErrorColor: Colors.blue[900],
                                    onChanged: (value) {
                                      setState(() {
                                        // checked = false;
                                      });

                                      _signupformKey.currentState!.validate();
                                    },
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'interfont'),
                                    keyboardType: TextInputType.emailAddress,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _signupformKey.currentState!.validate();
                                    },
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: primaryColor,
                                        ),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        prefixIcon: Icon(Icons.face_6),
                                        prefixIconColor: Colors.blueGrey,
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfsont',
                                        ),
                                        labelText: "Firstname",
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfont',
                                        ),
                                        hintText: "First name",
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
                                                color: Colors.blueGrey,
                                                width: 1.5)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 171, 18, 7),
                                                width: 1.5)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(255, 171, 18, 7),
                                                width: 1.5))),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'First name cannot be empty';
                                      }

                                      return null;
                                    },
                                    controller: firstname,
                                  ),
                                  TextFormField(
                                    cursorErrorColor: Colors.blue[900],
                                    onChanged: (value) {
                                      setState(() {
                                        // checked = false;
                                      });

                                      _signupformKey.currentState!.validate();
                                    },
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'interfont'),
                                    keyboardType: TextInputType.emailAddress,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _signupformKey.currentState!.validate();
                                    },
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: primaryColor,
                                        ),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        prefixIcon: Icon(Icons.face_6),
                                        prefixIconColor: Colors.blueGrey,
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfsont',
                                        ),
                                        labelText: "Lastname",
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfont',
                                        ),
                                        hintText: "Last name",
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
                                                color: Colors.blueGrey,
                                                width: 1.5)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 171, 18, 7),
                                                width: 1.5)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(255, 171, 18, 7),
                                                width: 1.5))),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Last name cannot be empty';
                                      }

                                      return null;
                                    },
                                    controller: lastname,
                                  ),
                                  TextFormField(
                                    cursorErrorColor: Colors.blue[900],
                                    onChanged: (value) {
                                      setState(() {
                                        // checked = false;
                                      });

                                      _signupformKey.currentState!.validate();
                                    },
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'interfont'),
                                    keyboardType: TextInputType.emailAddress,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _signupformKey.currentState!.validate();
                                    },
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: primaryColor,
                                        ),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        prefixIcon: isPhone
                                            ? const Icon(
                                                CupertinoIcons.mail_solid)
                                            : const Icon(CupertinoIcons.mail),
                                        prefixIconColor: Colors.blueGrey,
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfsont',
                                        ),
                                        labelText: "e-mail",
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfont',
                                        ),
                                        hintText: "Enter your Login ID.",
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
                                                color: Colors.blueGrey,
                                                width: 1.5)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 171, 18, 7),
                                                width: 1.5)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(color: Color.fromARGB(255, 171, 18, 7), width: 1.5))),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email id cannot be empty';
                                      }
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                    controller: _emailController,
                                  ),
                                  if (!isPhone)
                                    TextFormField(
                                      cursorErrorColor: Colors.blue[900],
                                      onChanged: (value) {
                                        setState(() {
                                          // checked = false;
                                        });

                                        _signupformKey.currentState!.validate();
                                      },
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'interfont'),
                                      keyboardType: TextInputType.phone,
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        _signupformKey.currentState!.validate();
                                      },
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            color: primaryColor,
                                          ),
                                          fillColor: Colors.grey.shade100,
                                          filled: true,
                                          prefixIcon: isPhone
                                              ? const Icon(
                                                  CupertinoIcons.phone_solid)
                                              : const Icon(CupertinoIcons
                                                  .phone_fill_badge_plus),
                                          prefixIconColor: Colors.blueGrey,
                                          labelStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey,
                                            fontFamily: 'interfsont',
                                          ),
                                          prefixText: '+91 ',
                                          prefixStyle: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 16),
                                          labelText: "Phone",
                                          hintStyle: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.blueGrey,
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
                                                  color: Colors.blueGrey,
                                                  width: 1.5)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Colors.blueGrey,
                                                  width: 1.5)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Color.fromARGB(255, 171, 18, 7),
                                                  width: 1.5)),
                                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color.fromARGB(255, 171, 18, 7), width: 1.5))),
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
                                  if (!isPhone)
                                    TextFormField(
                                      cursorErrorColor: Colors.blue[900],
                                      controller: _addressController,
                                      maxLines: 3,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'interfont'),
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      decoration: InputDecoration(
                                        alignLabelWithHint: true,
                                        errorStyle: TextStyle(
                                          color: primaryColor,
                                        ),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        prefixIcon: const Icon(
                                          Icons.location_on,
                                        ),
                                        prefixIconColor: Colors.blueGrey,
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfsont',
                                        ),
                                        labelText: "Address",
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                          fontFamily: 'interfont',
                                        ),
                                        hintText: "Enter your complete address",
                                        focusColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 4, 59, 103),
                                                width: 1.5)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.blueGrey,
                                                width: 1.5)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 171, 18, 7),
                                                width: 1.5)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 171, 18, 7),
                                                width: 1.5)),
                                      ),
                                      onChanged: (value) {
                                        _signupformKey.currentState!.validate();
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Address cannot be empty';
                                        }
                                        if (value.length < 10) {
                                          return 'Please enter a complete address';
                                        }
                                        return null;
                                      },
                                    ),
                                  TextFormField(
                                    onChanged: (value) {
                                      _signupformKey.currentState!.validate();
                                    },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'interfont',
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      prefixIcon: const Icon(
                                          CupertinoIcons.lock_circle_fill),
                                      prefixIconColor: Colors.blueGrey,
                                      suffixIconColor: primaryColor,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _newPasswordVisible
                                              ? CupertinoIcons.eye_slash
                                              : CupertinoIcons.eye,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _newPasswordVisible =
                                                !_newPasswordVisible;
                                          });
                                        },
                                      ),
                                      labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey,
                                        fontFamily: 'interfsont',
                                      ),
                                      errorStyle: TextStyle(
                                        color: primaryColor,
                                      ),
                                      labelText: "New Password",
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'interfont',
                                        fontSize: 17,
                                      ),
                                      hintText: "Enter New Password",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 4, 59, 103),
                                              width: 1.5)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Colors.blueGrey,
                                              width: 1.5)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 171, 18, 7),
                                              width: 1.5)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 171, 18, 7),
                                              width: 1.5)),
                                      errorMaxLines: 3,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      if (value.length < 6 ||
                                          value.length > 32) {
                                        return 'Password must be between 6 and 32 characters';
                                      }
                                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                          .hasMatch(value)) {
                                        return 'Password must contain at least one special character';
                                      }
                                      if (!RegExp(r'[a-zA-Z]')
                                          .hasMatch(value)) {
                                        return 'Password must contain at least one letter character';
                                      }
                                      if (!RegExp(r'\d').hasMatch(value)) {
                                        return 'Password must contain at least one number';
                                      }
                                      return null;
                                    },
                                    controller: _newPasswordController,
                                    obscureText: _newPasswordVisible,
                                  ),
                                  TextFormField(
                                    onChanged: (value) {
                                      _signupformKey.currentState!.validate();
                                    },
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'interfont'),
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                        color: primaryColor,
                                      ),
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      prefixIcon: const Icon(
                                          CupertinoIcons.lock_circle_fill),
                                      prefixIconColor: Colors.blueGrey,
                                      suffixIconColor: primaryColor,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _confirmPasswordVisible
                                              ? CupertinoIcons.eye_slash
                                              : CupertinoIcons.eye,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _confirmPasswordVisible =
                                                !_confirmPasswordVisible;
                                          });
                                        },
                                      ),
                                      labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey,
                                        fontFamily: 'interfsont',
                                      ),
                                      labelText: "Confirm Password",
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'interfont',
                                        fontSize: 17,
                                      ),
                                      hintText: "Enter Confirm Password",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 4, 59, 103),
                                              width: 1.5)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Colors.blueGrey,
                                              width: 1.5)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 171, 18, 7),
                                              width: 1.5)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 171, 18, 7),
                                              width: 1.5)),
                                    ),
                                    validator: validatePasswordMatch,
                                    controller: _confirmPasswordController,
                                    obscureText: _confirmPasswordVisible,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      context.read<UserCubit>().initState();
                                    },
                                    child: Text(
                                      "SignIn as a User?",
                                      style: TextStyle(
                                          color: primaryColor,
                                          height: .8,
                                          decoration: TextDecoration.underline,
                                          fontSize: 15),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (state is LoginLoading) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: AnimatedTextKit(animatedTexts: [
                              TyperAnimatedText(
                                'Loading ...',
                                speed: Duration(milliseconds: 100),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ]))
                          ]))));
        } else {
          log(state.toString());
          return Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          spacing: 35,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: AnimatedTextKit(animatedTexts: [
                              TyperAnimatedText(
                                'Unable to Login ...',
                                speed: Duration(milliseconds: 100),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ])),
                            ElevatedButton(
                              onPressed: () {
                                context.read<UserCubit>().initState();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ]))));
        }
      },
    );
  }

  String? validatePasswordMatch(String? value) {
    if (value != _newPasswordController.text && value!.isNotEmpty) {
      return 'Passwords do not match';
    }
    if (value!.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
