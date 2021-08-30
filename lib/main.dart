import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

//This app need to enable direction api and map android sdk map ios sdk
//But you need to enable billing account on google maps developer console thats the point
//You need to also give to permission both of ios and android permission
//like android access_fine_location

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Set<Polyline> polyline = {};

  GoogleMapController _controller;
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: 'Your Api Key');

  //This one is for the drive
  //And this one draw to routes between brooklyn to bushwick
  getSomePoints() async {
    var permission =
        await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permission[0].permissionStatus == PermissionStatus.notAgain) {
      var askPermission =
          await Permission.requestPermissions([PermissionName.Location]);
    } else {
      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(
            40.6782,
            -73.9442,
          ),
          destination: LatLng(
            40.6782,
            -73.9212,
          ),
          mode: RouteMode.driving);
    }
  }

  //This one draw for the walk and bicycle
  getAddressPoint() async {
    routeCoords = await googleMapPolyline.getPolylineCoordinatesWithAddress(
        origin: '55 Kingston Ave, Brooklyn, NY 11213, USA',
        destination: '178 Broadway, Brooklyn, NY 11211, USA',
        mode: RouteMode.driving);
  }

  @override
  void initState() {
    getSomePoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(
              40.6782,
              -73.9442,
            ),
            zoom: 14.0),
        mapType: MapType.normal,
        polylines: polyline,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;

      polyline.add(Polyline(
        polylineId: PolylineId('route1'),
        visible: true,
        points: routeCoords,
        width: 4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
      ));
    });
  }
}
