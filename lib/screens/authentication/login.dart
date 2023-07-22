import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../services/service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phonenumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    phonenumberController.dispose();
    super.dispose();
  }

  Future loginReqest() async {
    Map<String, String> json = {"phone": phonenumberController.text};
    String body = jsonEncode(json);
    var response = await ApiService().authLogin(body);
    var data = jsonDecode(response.body.toString());
    print("response $data");
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OTPScreen(otp: data['otp'].toString(), phone: phonenumberController.text)));
  }

  String? validateMobileNumber(String value) {
    if (value.length != 10) {
      return 'Enter valid 10 digit mobile number';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/auth.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 25,
            ),
            loginField(),
            loginBtn(),
          ],
        ),
      ),
    );
  }

  Widget loginField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: phonenumberController,
        keyboardType: TextInputType.phone,
        inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            // prefixText: '+91',
            prefixIcon: const Text('  +91'),
            prefixIconColor: Colors.black,
            prefixIconConstraints: const BoxConstraints(minWidth: 40, maxHeight: 20),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }

  Widget loginBtn() {
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
            onPressed: () => loginReqest())); //
  }
}
