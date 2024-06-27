


// import 'package:flutter/material.dart';
// import 'package:http_dio/features/location/presentation/pages/current_location.dart';
// import 'package:http_dio/features/location/presentation/pages/map_screen.dart';


// class ButtonScreen extends StatefulWidget {
//   const ButtonScreen({Key? key}) : super(key: key);

//   @override
//   _ButtonScreenState createState() => _ButtonScreenState();
// }

// class _ButtonScreenState extends State<ButtonScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Flutter Google Maps"),
//         centerTitle: true,
//       ),
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: [
//             ElevatedButton(onPressed: (){
//               Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
//                 return const SimpleMapScreen();
//               }));
//             }, child: const Text("Simple Map")),

//             ElevatedButton(onPressed: (){
//               Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
//                 return const CurrentLocationScreen();
//               }));
//             }, child: const Text("User current location")),

           
          

//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


import 'package:url_launcher/url_launcher_string.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  String currentAddress = 'My Address';
  Position? currentPosition;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please keep your location on');
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permission is denied');
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Permission is denied forever');
      throw Exception('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
        

    return position;
  }

  Future<void> _getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentPosition = position;
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      // _liveLoction();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error getting address: $e');
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      await _getAddressFromPosition(position);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  Future<void> _openMap(double? latitude, double? longitude) async{
    String googleURL = 'http://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await canLaunchUrlString(googleURL) ?
    await launchUrlString(googleURL) : throw 'Could not launch $googleURL';
  }
// void _liveLoction(){
//   LocationSettings locationSettings = const LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 10,
//   );
//   Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position){
//     currentPosition!.latitude=position.latitude.toString();
//         currentPosition!.longitude=position.longitude.toString();


//   });
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 220, 216, 214),
        title: Text('Geolocation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentAddress,
              style: TextStyle(fontSize: 20),
            ),
            if (currentPosition != null)
              Column(
                children: [
                  Text(
                    'Latitude: ${currentPosition!.latitude}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Longitude: ${currentPosition!.longitude}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 245, 115, 64)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: _getCurrentLocation,
                child: const Text('Get Current Location', style: TextStyle(fontSize: 18),),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 70, 140, 239)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: (){
                  _openMap(currentPosition?.latitude, currentPosition?.longitude);
                },
                child: const Text('Show on map', style: TextStyle(fontSize: 18),),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
