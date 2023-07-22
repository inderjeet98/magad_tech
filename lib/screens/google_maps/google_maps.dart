// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({Key? key, required this.userId, required this.userName, required this.userPhone, required this.lat, required this.long, required this.userEmail}) : super(key: key);
  final String userName, userId, userPhone, userEmail;
  final double lat, long;

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  final Map<String, Marker> _markers = {};
  late GoogleMapController mapController;

  // final LatLng _center = const LatLng(45.521563, -122.677433);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    // final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      // for (final office in googleOffices.offices) {
      final marker = Marker(
        markerId: MarkerId(widget.userId),
        position: LatLng(widget.lat, widget.long),
        infoWindow: InfoWindow(
          title: widget.userName,
          snippet: 'Phone No: ${widget.userPhone}\n Email: ${widget.userEmail}',
        ),
      );
      _markers[widget.userId] = marker;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        elevation: 2,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.long),
          zoom: 22,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
