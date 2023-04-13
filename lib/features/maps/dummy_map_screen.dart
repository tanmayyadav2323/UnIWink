// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late MapboxMapController _mapController;
//   late LatLng _selectedLocation;
//   CameraPosition _initialCameraPosition =
//       CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 12.0);
//   String _accessToken =
//       'pk.eyJ1IjoidGFubWF5eWFkYXYyMzIzIiwiYSI6ImNsZ2ZnOHN2cTAxZDMzbW81amdibTR0emIifQ.FJ0c5op52SAnjwW_Iou8PA';

//   void _onMapCreated(MapboxMapController controller) {
//     _mapController = controller;
//   }

//   void _onMapTap(LatLng location) {
//     setState(() {
//       _selectedLocation = location;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mapbox Map Demo'),
//       ),
//       body: MapboxMap(
//         accessToken: _accessToken,
//         onMapCreated: _onMapCreated,
//         onMapClick: (_, x) => _onMapTap(x),
//         initialCameraPosition: _initialCameraPosition,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Save the selected location and return to the previous screen
//           Navigator.pop(context, _selectedLocation);
//         },
//         child: Icon(Icons.check),
//       ),
//     );
//   }
// }
// // 