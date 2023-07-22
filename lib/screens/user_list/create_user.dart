// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../services/service.dart';
import 'user_list.dart';
import '../../widgets/designconfig.dart';
import '../../widgets/custom_formfield.dart';
import '../../utils/extension.dart';
import '../../model/create_user_model.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //geoLocation
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  late StreamSubscription<Position> positionStream;
  String long = "", lat = "";

  @override
  void initState() {
    super.initState();
    checkGps();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    latController.dispose();
    longController.dispose();
    super.dispose();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        await getLocation();
        setState(() {
          //refresh the UI
          latController.text = lat;
          longController.text = long;
        });
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: true);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toStringAsFixed(3);
    lat = position.latitude.toStringAsFixed(3);

    setState(() {
      //refresh UI
      latController.text = lat;
      longController.text = long;
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toStringAsFixed(3);
      lat = position.latitude.toStringAsFixed(3);

      setState(() {
        //refresh UI on update
        latController.text = lat;
        longController.text = long;
      });
    });
  }

  getCurrentLoaction() async {
    if ((long.isEmpty && lat.isEmpty) || (long == "" && lat == "")) {
      await showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(""),
          content: const Text('Please Enable GPS Location', textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                checkGps();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      await checkGps();
    }
  }

  Future saveDetails() async {
    lat = lat.isEmpty ? '0' : lat;
    long = long.isEmpty ? '0' : long;
    Location location = Location(latitude: double.parse(lat), longitude: double.parse(long));
    SaveUser newUserJson = SaveUser(name: nameController.text, email: emailController.text, phone: phoneController.text, location: location);
    String finalUserJson = jsonEncode(newUserJson);
    print(finalUserJson);
    var response = await ApiService().createUser(finalUserJson);
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response != null && !response.hasError) {
      showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(""),
          content: const Text('User has been Created Successfully', textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserList()));
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                checkGps();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New User'),
        elevation: 1,
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: mainScreen(),
      )),
    );
  }

  Widget mainScreen() {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          keyboardType: TextInputType.name,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))],
          // validator: (val) {
          //   if (!val!.isValidName) return 'Enter valid name';
          // },
          decoration: const InputDecoration(hintText: 'Name'),
        ),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (!val!.isValidEmail) return 'Enter valid EmailId';
          },
          decoration: const InputDecoration(hintText: 'Email'),
        ),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))],
          // validator: (val) {
          //   if (!val!.isValidPhone) return 'Enter valid phone number';
          // },
          decoration: const InputDecoration(hintText: 'Phone Number'),
        ),
        TextFormField(
          controller: latController,
          readOnly: true,
          decoration: const InputDecoration(hintText: 'Latitude'),
        ),
        TextFormField(
          controller: longController,
          readOnly: true,
          decoration: const InputDecoration(hintText: 'Longitude'),
        ),
        // CustomFormFields(
        //   hintText: 'Longitude',
        //   controller: longController,
        //   readOnly: true,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => getCurrentLoaction(),
              child: const Text('Get Location'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveDetails();
                }
              },
              child: const Text('Submit'),
            )
          ],
        )
      ],
    );
  }
}
