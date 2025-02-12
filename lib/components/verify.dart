import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> with CodeAutoFill {
  String _otpCode = "";
  bool _isLoading = false;
  Box box = Hive.box('laundry');

  @override
  void codeUpdated() {
    setState(() {
      _otpCode = code!;
    });
    _verifyOTP();
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  void _verifyOTP() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      box.put('phoneNumber', widget.phoneNumber);

      print("OTP entered: $_otpCode");
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter the 6-digit OTP sent to your phone:",
                style: TextStyle(fontSize: 18, color: Colors.blueGrey.shade600),
              ),
              const SizedBox(
                height: 16,
              ),
              PinFieldAutoFill(
                codeLength: 6,
                currentCode: _otpCode,
                onCodeChanged: (code) {
                  if (code!.length == 6) {
                    setState(() {
                      _otpCode = code;
                    });
                    _verifyOTP();
                  }
                },
                decoration: UnderlineDecoration(
                  textStyle: const TextStyle(fontSize: 24, color: Colors.black),
                  colorBuilder: const FixedColorBuilder(Colors.black),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                      ),
                      child: const Text("Verify"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
