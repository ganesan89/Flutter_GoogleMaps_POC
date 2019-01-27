import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Imporing the model object class
import './coordinate.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
//Setting Initial Position 'Hudson Coordinates'
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(44.974758, -92.758080),
    zoom: 11.0,
  );

//Initializing GoogleMapCOntroller
  GoogleMapController mapController;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = true;

/** Initializing Map Listening Method */
  void _onMapChanged() {
    setState(() {
      _reloadMapInfo();
    });
  }

/**
 * Reloading Google Maps
 */
  void _reloadMapInfo() {
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

/**Initializing MapCOntroller */
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _reloadMapInfo();
  }

/**
 * Method for displaying the selcted Cities
 */
  void onTapListItem(Coordinate coordinate) {
    //Changing the camera position to selcted location position
    LatLng targetPosition = LatLng(coordinate.latitude, coordinate.longitude);
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: targetPosition,
        zoom: 10.0,
      ),
    ));

    //setting Markers
    mapController.addMarker(
      MarkerOptions(
        position: targetPosition,
        infoWindowText:InfoWindowText(coordinate.city, coordinate.state),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    //screen Size
    final screenSize = MediaQuery.of(context).size;

    //Instance of Google Maps
    final GoogleMap googleMap = GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      cameraTargetBounds: CameraTargetBounds.unbounded,
      minMaxZoomPreference: MinMaxZoomPreference.unbounded,
      mapType: MapType.normal,
      trackCameraPosition: true,
    );

    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: screenSize.width,
            height:300,
            child: googleMap,
          ),
        ),
      ),
    ];

    if (mapController != null) {
      columnChildren.add(
        Expanded(
          child: StreamBuilder(
            stream: Firestore.instance.collection('cities').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  //Firebase Data object
                  var obj = snapshot.data.documents[index];
                  //converting data into Model Object
                  Coordinate coordinate = new Coordinate.fromJson(obj);
                  return ListTile(
                    title: new Card(
                      elevation: 5.0,
                      child: new Container(
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.only(
                            left: 10, top: 15.0, bottom: 15.0),
                        child: Text(coordinate.city + ',' + coordinate.state),
                      ),
                    ),
                    onTap: () {
                      onTapListItem(coordinate);
                    },
                  );
                },
              );
            },
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );
  }
}
