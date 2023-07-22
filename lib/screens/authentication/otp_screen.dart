import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import '../../services/service.dart';
import '../user_list/user_list.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key, required this.otp, required this.phone}) : super(key: key);
  final String otp, phone;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codeController.text = widget.otp;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future verifyOtp() async {
    String otp = codeController.text;
    Map<String, String> otpJson = {"phone": widget.phone, "otp": otp};
    String otpBody = jsonEncode(otpJson);
    var otpVerify = await ApiService().verifyLogin(otpBody);
    print(otpVerify);
    String token = otpVerify['token'];
    var tokenResponse = await ApiService().verifyToken(token);
    print(tokenResponse);
    String tokenForUserList = tokenResponse['user']['token'];
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserList(token: tokenForUserList)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          'assets/images/auth.png',
          width: 150,
          height: 150,
        ),
        const SizedBox(
          height: 25,
        ),
        otpFiled(),
        verifyOtpBtn()
      ]),
    );
  }

  Widget otpFiled() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Pinput(
        controller: codeController,
        length: 6,
        showCursor: true,
        onCompleted: (pin) => verifyOtp(),
      ),
    );
  }

  Widget verifyOtpBtn() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll<Color>(Colors.green),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => verifyOtp())); //
  }
}
