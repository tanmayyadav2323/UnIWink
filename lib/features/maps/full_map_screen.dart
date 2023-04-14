// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:buddy_go/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FullMapScreen extends StatefulWidget {
  static const routename = 'full-map-screen';
  final double latitude;
  final double longitude;

  const FullMapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 1.h,
            ),
            Text(
              "Location",
              style: GoogleFonts.poppins(fontSize: 20.sp, color: Colors.white),
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(widget.latitude, widget.longitude),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 30.0,
                        height: 30.0,
                        point: LatLng(widget.latitude, widget.longitude),
                        builder: (ctx) => Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            CustomButton(
                buttonText: "Open Map",
                onPressed: () async {
                  String googleMapsUrl =
                      'geo:${widget.latitude},${widget.longitude}';
                  if (true) {
                    await launchURL(context, googleMapsUrl);
                  } else {
                    throw 'Could not launch Google Maps.';
                  }
                })
          ],
        ),
      ),
    );
  }
}
