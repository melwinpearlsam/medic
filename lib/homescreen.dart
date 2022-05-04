import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _controller;
  Location currentLocation = Location();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocation();
    });
  }

  BitmapDescriptor? _locationIcon;

  late final String title;
  final _controler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(48.8561, 2.2930),
            zoom: 12.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          markers: _markers,
          zoomControlsEnabled: false,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            child: GestureDetector(
              onTap: () {
                bookambulance(context);
              },
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                child: Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                ),
              ),
            ))

        // Align(
        //   floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        //   alignment: Alignment.bottomRight
        //     FloatingActionButton.extended(
        //       //label: const Text('Get Medic'),
        //       icon: const Icon(MyFlutterApp.ambulance),
        //       label: Text('Book Ambulance'),
        //       backgroundColor: Colors.pink,
        //       onPressed: () {
        //         _getMyLocation();
        //         _setMarker(currentLocation);
        //         //showBottomSheet(context);
        //       },
        //     ),
        //     FloatingActionButton(
        //       onPressed: () {},
        //       child: Icon(Icons.settings),
        //     )
        //       ),
        );
  }

  // void _setMarker(LatLng _location) {
  //   Marker newMarker = Marker(
  //     markerId: MarkerId(_location.toString()),
  //     icon: BitmapDescriptor.defaultMarker,
  //     // icon: _locationIcon,
  //     position: _location,
  //     infoWindow: InfoWindow(
  //         title: "Title",
  //         snippet: "${currentLocation.latitude}, ${currentLocation.longitude}"),
  //   );
  //   _markers.add(newMarker);
  //   setState(() {});
  // }

  // Future<void> _buildMarkerFromAssets() async {
  //   if (_locationIcon == null) {
  //     _locationIcon = await BitmapDescriptor.fromAssetImage(
  //         ImageConfiguration(size: Size(48, 48)),
  //         'assets/images/location_icon.png');
  //     setState(() {});
  //   }
  // }

  Future<void> getLocation() async {
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 12.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _markers.add(Marker(
            markerId: const MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
      });
      // setState(() {
      //   getLocation();
      // });
    });
  }

  // Future<void> _getMyLocation() async {
  //   LocationData _myLocation = await LocationService().getLocation();
  //   _animateCamera(LatLng(_myLocation.latitude!, _myLocation.longitude!));
  // }

  // Future<void> _animateCamera(LatLng _location) async {
  //   final GoogleMapController controller = await _controller.future;
  //   CameraPosition _cameraPosition = CameraPosition(
  //     target: _location,
  //     zoom: 13.00,
  //   );
  //   print(
  //       "animating camera to (lat: ${_location.latitude}, long: ${_location.longitude}");
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  // }

  // Future<void> showBottomSheet(BuildContext ctx) async {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
  //     ),
  //     context: ctx,
  //     builder: (ctx) {
  //       return ListView.separated(
  //         itemBuilder: (ctx, index) {
  //           return ListTile(
  //             title: Text(''),
  //           );
  //         },
  //         separatorBuilder: (ctx, index) {
  //           return Divider();
  //         },
  //         itemCount: 4,
  //       );
  //     },
  //   );
  // }

  void bookambulance(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx1) {
          return AlertDialog(
            title: const Text('Booking Ambulance'),
            content: const Text("Ambulance is on the way"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx1).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
}
