import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appentus_task/second_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const apiKey = "AIzaSyAcslNdK7az-GenMrL42WgzpJL1n83vG0E";

class HomePage extends StatefulWidget {
  final String name;
  final String photo;

  HomePage({this.name, this.photo});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool giveLocation = false;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};

  Set<Polyline> get polyLines => _polyLines;
  Completer<GoogleMapController> _controller = Completer();
  static LatLng latLng;
  LocationData currentLocation;
  bool confirm = false;

  @override
  void initState() {
    super.initState();
  }

  getLocation() async {
    if (giveLocation == true) {
      var location = new Location();
      location.onLocationChanged.listen((currentLocation) async {
        setState(() {
          latLng = LatLng(currentLocation.latitude, currentLocation.longitude);
        });
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target:
                    LatLng(currentLocation.latitude, currentLocation.longitude),
                zoom: 14),
          ),
        );
        _onAddMarkerButtonPressed();
        giveLocation = false;
      });
    }
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("111"),
        position: latLng,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'Home', snippet: 'My current location'),
      ));
    });
  }

  void onCameraMove(CameraPosition position) {
    latLng = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SecondPage())),
          backgroundColor: Color.fromRGBO(68, 76, 140, 1),
          label: Text('Next!'),
          icon: Icon(Icons.forward_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color.fromRGBO(68, 76, 140, 1),
              pinned: true,
              floating: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(widget.name),
                background: Image.memory(
                  base64Decode(widget.photo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  width: double.infinity,
                  height: 800,
                  child: Stack(
                    children: <Widget>[
                      GoogleMap(
                        polylines: polyLines,
                        markers: _markers,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(26.9202586, 75.7869392),
                          zoom: 14.4746,
                        ),
                        onCameraMove: onCameraMove,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          setState(() {
                            giveLocation = true;
                          });
                          getLocation();
                        },
                      ),
                    ],
                  ),
                )
              ]),
            )
          ],
        ));
  }
}
