import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';

class PlacePickerScreen extends StatefulWidget {
  @override
  _PlacePickerScreenState createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  late GoogleMapController _mapController;
  LatLng _initialCameraPosition = LatLng(37.42796133580664, -122.085749655962);
  late LatLng _currentLocation;
  late Marker _marker;
  String _searchAddress = '';

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    _currentLocation = LatLng(position.latitude, position.longitude);
    _marker = Marker(
      markerId: MarkerId("current_location"),
      position: _currentLocation,
      draggable: true,
      onDrag: (value) {},
      onDragEnd: (newPosition) {
        _updateMarkerPosition(newPosition);
      },
      infoWindow: InfoWindow(
        title: "Current Location",
      ),
    );
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation,
          zoom: 15.0,
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _searchLocation(address) async {
    List<Location> locations = await locationFromAddress(address);
    _searchAddress = address;
    if (locations.isNotEmpty) {
      setState(() {
        LatLng selectedLocation =
            LatLng(locations[0].latitude, locations[0].longitude);
        _updateMarkerPosition(selectedLocation);
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: selectedLocation,
              zoom: 15.0,
            ),
          ),
        );
      });
    }
  }

  void _updateMarkerPosition(LatLng newPosition) {
    setState(() {
      _marker = _marker.copyWith(
        positionParam: newPosition,
        draggableParam: true,
        iconParam:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _marker = Marker(
      markerId: MarkerId('id'),
      draggable: true,
      onDragEnd: (newPosition) {
        _updateMarkerPosition(newPosition);
      },
      onDrag: (value) {},
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(
        title: "Current Location",
      ),
    );
    _currentLocation = LatLng(0, 0);
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place Picker"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialCameraPosition,
              zoom: 10.0,
            ),
            zoomControlsEnabled: false,
            markers: {_marker},
          ),
          SearchGooglePlacesWidget(
            apiKey: 'AIzaSyALpq-JTqFt9DBBa999TbonX1iX8FzOtyM',
            language: 'en',
            onSearch: (place) {
              log(place.toString());
            },
            radius: 30000,
            location: _currentLocation,
            onSelected: (Place place) async {
              final geolocation = await place.geolocation;
              // final GoogleMapController controller =
              //     await _mapController.future;
              // controller.animateCamera(
              //     CameraUpdate.newLatLng(geolocation.coordinates));
              // controller.animateCamera(
              //     CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
