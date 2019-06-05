// // import 'dart:async';
// // import 'dart:math';
// // import 'dart:typed_data';
// // import 'dart:ui';

// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// // class PlaceMarkerBody extends StatefulWidget {
// //   const PlaceMarkerBody();

// //   @override
// //   State<StatefulWidget> createState() => PlaceMarkerBodyState();
// // }

// // typedef Marker MarkerUpdateAction(Marker marker);

// // class PlaceMarkerBodyState extends State<PlaceMarkerBody> {
// //   PlaceMarkerBodyState();

// //   static final LatLng center = const LatLng(-33.86711, 151.1947171);

// //   GoogleMapController controller;
// //   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
// //   MarkerId selectedMarker;
// //   int _markerIdCounter = 1;

// //   void _onMapCreated(GoogleMapController controller) {
// //     this.controller = controller;
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //   }

// //   void _onMarkerTapped(MarkerId markerId) {
// //     final Marker tappedMarker = markers[markerId];
// //     if (tappedMarker != null) {
// //       setState(() {
// //         if (markers.containsKey(selectedMarker)) {
// //           final Marker resetOld = markers[selectedMarker]
// //               .copyWith(iconParam: BitmapDescriptor.defaultMarker);
// //           markers[selectedMarker] = resetOld;
// //         }
// //         selectedMarker = markerId;
// //         final Marker newMarker = tappedMarker.copyWith(
// //           iconParam: BitmapDescriptor.defaultMarkerWithHue(
// //             BitmapDescriptor.hueGreen,
// //           ),
// //         );
// //         markers[markerId] = newMarker;
// //       });
// //     }
// //   }

// //   void _add() {
// //     final int markerCount = markers.length;

// //     if (markerCount == 12) {
// //       return;
// //     }

// //     final String markerIdVal = 'marker_id_$_markerIdCounter';
// //     _markerIdCounter++;
// //     final MarkerId markerId = MarkerId(markerIdVal);

// //     final Marker marker = Marker(
// //       markerId: markerId,
// //       position: LatLng(
// //         center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
// //         center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
// //       ),
// //       infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
// //       onTap: () {
// //         _onMarkerTapped(markerId);
// //       },
// //     );

// //     setState(() {
// //       markers[markerId] = marker;
// //     });
// //   }

// //   void _remove() {
// //     setState(() {
// //       if (markers.containsKey(selectedMarker)) {
// //         markers.remove(selectedMarker);
// //       }
// //     });
// //   }

// //   void _changePosition() {
// //     final Marker marker = markers[selectedMarker];
// //     final LatLng current = marker.position;
// //     final Offset offset = Offset(
// //       center.latitude - current.latitude,
// //       center.longitude - current.longitude,
// //     );
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         positionParam: LatLng(
// //           center.latitude + offset.dy,
// //           center.longitude + offset.dx,
// //         ),
// //       );
// //     });
// //   }

// //   void _changeAnchor() {
// //     final Marker marker = markers[selectedMarker];
// //     final Offset currentAnchor = marker.anchor;
// //     final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         anchorParam: newAnchor,
// //       );
// //     });
// //   }

// //   Future<void> _changeInfoAnchor() async {
// //     final Marker marker = markers[selectedMarker];
// //     final Offset currentAnchor = marker.infoWindow.anchor;
// //     final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         infoWindowParam: marker.infoWindow.copyWith(
// //           anchorParam: newAnchor,
// //         ),
// //       );
// //     });
// //   }

// //   Future<void> _toggleDraggable() async {
// //     final Marker marker = markers[selectedMarker];
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         draggableParam: !marker.draggable,
// //       );
// //     });
// //   }

// //   Future<void> _toggleFlat() async {
// //     final Marker marker = markers[selectedMarker];
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         flatParam: !marker.flat,
// //       );
// //     });
// //   }

// //   Future<void> _changeInfo() async {
// //     final Marker marker = markers[selectedMarker];
// //     final String newSnippet = marker.infoWindow.snippet + '*';
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         infoWindowParam: marker.infoWindow.copyWith(
// //           snippetParam: newSnippet,
// //         ),
// //       );
// //     });
// //   }

// //   Future<void> _changeAlpha() async {
// //     final Marker marker = markers[selectedMarker];
// //     final double current = marker.alpha;
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         alphaParam: current < 0.1 ? 1.0 : current * 0.75,
// //       );
// //     });
// //   }

// //   Future<void> _changeRotation() async {
// //     final Marker marker = markers[selectedMarker];
// //     final double current = marker.rotation;
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         rotationParam: current == 330.0 ? 0.0 : current + 30.0,
// //       );
// //     });
// //   }

// //   Future<void> _toggleVisible() async {
// //     final Marker marker = markers[selectedMarker];
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         visibleParam: !marker.visible,
// //       );
// //     });
// //   }

// //   Future<void> _changeZIndex() async {
// //     final Marker marker = markers[selectedMarker];
// //     final double current = marker.zIndex;
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         zIndexParam: current == 12.0 ? 0.0 : current + 1.0,
// //       );
// //     });
// //   }

// //   void _setMarkerIcon(BitmapDescriptor assetIcon) {
// //     if (selectedMarker == null) {
// //       return;
// //     }

// //     final Marker marker = markers[selectedMarker];
// //     setState(() {
// //       markers[selectedMarker] = marker.copyWith(
// //         iconParam: assetIcon,
// //       );
// //     });
// //   }

// //   Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
// //     final Completer<BitmapDescriptor> bitmapIcon =
// //         Completer<BitmapDescriptor>();
// //     final ImageConfiguration config = createLocalImageConfiguration(context);

// //     const AssetImage('assets/red_square.png')
// //         .resolve(config)
// //         .addListener((ImageInfo image, bool sync) async {
// //       final ByteData bytes =
// //           await image.image.toByteData(format: ImageByteFormat.png);
// //       final BitmapDescriptor bitmap =
// //           BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
// //       bitmapIcon.complete(bitmap);
// //     });

// //     return await bitmapIcon.future;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: <Widget>[
// //         Center(
// //           child: SizedBox(
// //             width: 300.0,
// //             height: 200.0,
// //             child: GoogleMap(
// //               onMapCreated: _onMapCreated,
// //               initialCameraPosition: const CameraPosition(
// //                 target: LatLng(-33.852, 151.211),
// //                 zoom: 11.0,
// //               ),

// //               markers: Set<Marker>.of(markers.values),
// //             ),
// //           ),
// //         ),
// //         Expanded(
// //           child: SingleChildScrollView(
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: <Widget>[
// //                 Row(
// //                   children: <Widget>[
// //                     Column(
// //                       children: <Widget>[
// //                         FlatButton(
// //                           child: const Text('add'),
// //                           onPressed: _add,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('remove'),
// //                           onPressed: _remove,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('change info'),
// //                           onPressed: _changeInfo,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('change info anchor'),
// //                           onPressed: _changeInfoAnchor,
// //                         ),
// //                       ],
// //                     ),
// //                     Column(
// //                       children: <Widget>[
// //                         FlatButton(
// //                           child: const Text('change alpha'),
// //                           onPressed: _changeAlpha,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('change anchor'),
// //                           onPressed: _changeAnchor,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('toggle draggable'),
// //                           onPressed: _toggleDraggable,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('toggle flat'),
// //                           onPressed: _toggleFlat,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('change position'),
// //                           onPressed: _changePosition,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('change rotation'),
// //                           onPressed: _changeRotation,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('toggle visible'),
// //                           onPressed: _toggleVisible,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('change zIndex'),
// //                           onPressed: _changeZIndex,
// //                         ),
// //                         FlatButton(
// //                           child: const Text('set marker icon'),
// //                           onPressed: () {
// //                             _getAssetIcon(context).then(
// //                               (BitmapDescriptor icon) {
// //                                 _setMarkerIcon(icon);
// //                               },
// //                             );
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// // import '../../gallery/demo.dart';

// const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
// const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
// const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

// class CupertinoSegmentedControlDemo extends StatefulWidget {
//   static const String routeName = 'cupertino/segmented_control';

//   @override
//   _CupertinoSegmentedControlDemoState createState() =>
//       _CupertinoSegmentedControlDemoState();
// }

// class _CupertinoSegmentedControlDemoState
//     extends State<CupertinoSegmentedControlDemo> {
//   final Map<int, Widget> children = const <int, Widget>{
//     0: Text('Blocks'),
//     1: Text('Structures'),
//   };

//   final Map<int, Widget> icons = const <int, Widget>{
//     0: Center(
//       child: FlutterLogo(
//         colors: Colors.indigo,
//         size: 200.0,
//       ),
//     ),
//     1: Center(
//       child: FlutterLogo(
//         colors: Colors.teal,
//         size: 200.0,
//       ),
//     ),
//   };

//   int sharedValue = 0;

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: const Text('Segmented Control'),
//         // We're specifying a back label here because the previous page is a
//         // Material page. CupertinoPageRoutes could auto-populate these back
//         // labels.
//         previousPageTitle: 'Cupertino',
//         // trailing: CupertinoDemoDocumentationButton(CupertinoSegmentedControlDemo.routeName),
//       ),
//       child: DefaultTextStyle(
//         style: CupertinoTheme.of(context).textTheme.textStyle,
//         child: SafeArea(
//           child: Column(
//             children: <Widget>[
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//               ),
//               SizedBox(
//                 width: 500.0,
//                 child: CupertinoSegmentedControl<int>(
//                   children: children,
//                   onValueChanged: (int newValue) {
//                     setState(() {
//                       sharedValue = newValue;
//                     });
//                   },
//                   groupValue: sharedValue,
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 32.0,
//                     horizontal: 16.0,
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 64.0,
//                       horizontal: 16.0,
//                     ),
//                     decoration: BoxDecoration(
//                       color: CupertinoTheme.of(context).scaffoldBackgroundColor,
//                       borderRadius: BorderRadius.circular(3.0),
//                       boxShadow: const <BoxShadow>[
//                         BoxShadow(
//                           offset: Offset(0.0, 3.0),
//                           blurRadius: 5.0,
//                           spreadRadius: -1.0,
//                           color: _kKeyUmbraOpacity,
//                         ),
//                         BoxShadow(
//                           offset: Offset(0.0, 6.0),
//                           blurRadius: 10.0,
//                           spreadRadius: 0.0,
//                           color: _kKeyPenumbraOpacity,
//                         ),
//                         BoxShadow(
//                           offset: Offset(0.0, 1.0),
//                           blurRadius: 18.0,
//                           spreadRadius: 0.0,
//                           color: _kAmbientShadowOpacity,
//                         ),
//                       ],
//                     ),
//                     child: icons[sharedValue],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:islington_navigation_flutter/controller/utils/network.dart';
import 'package:islington_navigation_flutter/model/route.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:islington_navigation_flutter/model/app/structures.dart';


class MapScreen extends StatefulWidget {
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMap googleMap;
  MarkerId selectedMarker;

  // GoogleMapController mapController;
  GlobalKey<AutoCompleteTextFieldState<Structures>> key = new GlobalKey();

  StreamSubscription<LocationData> _locationSubscription;
  Location _location = new Location();

  LocationData _startLocation;
  LocationData _currentLocation;
  Location _locationService = new Location();
  CameraPosition _currentCameraPosition;

  double currentLatitude;
  double currentLongitude;

  String error;
  AutoCompleteTextField searchTextField;

  bool _permission = false;
  bool nullLocation = false;
  bool currentWidget = true;
  bool loading = true;
  bool empty = true;

  // NetworkUtil network = new NetworkUtil();

  // var location = new Location(0.0, 0.0);

  static List<Structures> structures = new List<Structures>();
  static List<Structures> structureIndividual = new List<Structures>();
  List<Location> ccc;

  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(0, 0),
    zoom: 5,
  );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getStructures() async {
    fetchAllStructures(http.Client()).then((value) {
      setState(() {
        structures = value;
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getLocation();
    getStructures();

    _locationSubscription =
        _location.onLocationChanged().listen((LocationData result) {
      setState(() {
        _currentLocation = result;
      });
    });

    setState(() {
      _currentLocation == null ? nullLocation = true : nullLocation = false;
    });
  }

  getLocation() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            currentLatitude = result.latitude;
            currentLongitude = result.longitude;
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude), zoom: 16);

            final GoogleMapController controller = await mapController.future;
            controller.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));

            if (mounted) {
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          getLocation();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }

  Widget row(Structures structures) {
    return loading
        ? CircularProgressIndicator()
        : Card(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      structures.structure_name,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      structures.structure_type,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    //method for popup logged out
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    List<Widget> widgets;

    // getDirectionSteps(double destinationLat, double destinationLng) {
    //   network
    //       .get("origin=" +
    //           currentLatitude.toString() +
    //           "," +
    //           currentLongitude.toString() +
    //           "&destination=" +
    //           destinationLat.toString() +
    //           "," +
    //           destinationLng.toString() +
    //           "&key=AIzaSyAiKSQQt83C7rUB8FYMTyULUzasBzgiDZE")
    //       .then((dynamic res) {
    //     List<Steps> rr = res;
    //     print(res.toString());

    //     ccc = new List();
    //     for (final i in rr) {
    //       ccc.add(i.startLocation);
    //       ccc.add(i.endLocation);
    //     }

    //     // googleMap.onMapCreated()

    //     // mapView.onMapReady.listen((_) {
    //     //   mapView.setMarkers(getMarker(location.latitude, location.longitude,
    //     //       destinationLat, destinationLng));
    //     //   mapView.addPolyline(new Polyline("12", ccc, width: 15.0));
    //     // });
    //     // _screenListener.dismissLoader();
    //     // showMap();
    //   }).catchError((Exception error) {
    //     print(error);
    //   } /*_screenListener.dismissLoader()*/);
    // }

    googleMap = GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialCamera,
      myLocationEnabled: true,
      markers: Set<Marker>.of(markers.values),
      onMapCreated: (GoogleMapController controller) {
        mapController.complete(controller);
      },
    );

    widgets = [
      Container(
        height: height,
        width: width,
        child: googleMap,
      ),
      Positioned(
        left: 0.0,
        right: 0.0,
        top: 20.0,
        height: 45.0,
        // width: double.infinity,
        child: Container(
          color: Colors.white,
          // height: MediaQuery.of(context).size.height * 0.30,
          height: 30.0,
          child: searchTextField = AutoCompleteTextField<Structures>(
            key: key,
            clearOnSubmit: false,
            suggestions: structures,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              // contentPadding:
              //     EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
              hintText: "Search structures",
              hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            itemFilter: (item, query) {
              return item.structure_name
                  .toLowerCase()
                  .startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.structure_name.compareTo(b.structure_name);
            },
            itemSubmitted: (item) {
              print("inside item submitted ${item.structure_name}");
              setState(() {
                searchTextField.textField.controller.text = item.structure_name;
              });
              fetchIndividualStructure(http.Client(), item.structure_id)
                  .then((onValue) {
                print("inside fetchindividualstructure");
                setState(() {
                  structureIndividual = onValue;
                  empty = !empty;
                  print("Empty is $empty");
                  print("Fetched list is : " + structureIndividual.toString());
                  print(
                      "latitude and longutude are: ${structureIndividual.first.latitude}, ${structureIndividual.first.longitude}");
                  // getDirectionSteps(structureIndividual.first.latitude,
                  //     structureIndividual.first.longitude);
                  _addMarkers();
                });
              }).whenComplete(() => _addMarkers());
            },
            itemBuilder: (context, item) {
              // ui for the autocompelete row
              return row(item);
            },
          ),
        ),
      ),
    ];

    return Scaffold(
        body: Column(
      children: <Widget>[
        searchTextField = AutoCompleteTextField<Structures>(
          key: key,
          clearOnSubmit: false,
          suggestions: structures,
          style: TextStyle(color: Colors.black, fontSize: 20.0),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            // contentPadding:
            //     EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
            hintText: "Search structures",
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          itemFilter: (item, query) {
            return item.structure_name
                .toLowerCase()
                .startsWith(query.toLowerCase());
          },
          itemSorter: (a, b) {
            return a.structure_name.compareTo(b.structure_name);
          },
          itemSubmitted: (item) {
            print("inside item submitted ${item.structure_name}");
            setState(() {
              searchTextField.textField.controller.text = item.structure_name;
            });
            fetchIndividualStructure(http.Client(), item.structure_id)
                .then((onValue) {
              print("inside fetchindividualstructure");
              setState(() {
                structureIndividual = onValue;
                empty = !empty;
                print("Empty is $empty");
                print("Fetched list is : " + structureIndividual.toString());
                print(
                    "latitude and longutude are: ${structureIndividual.first.latitude}, ${structureIndividual.first.longitude}");
                // getDirectionSteps(structureIndividual.first.latitude,
                //     structureIndividual.first.longitude);
                _addMarkers();
              });
            }).whenComplete(() => _addMarkers());
          },
          itemBuilder: (context, item) {
            // ui for the autocompelete row
            return row(item);
          },
        ),
        googleMap,
      ],
    )
        //     Stack(
        //   children: _currentCameraPosition == null
        //       ? CircularProgressIndicator()
        //       : widgets,
        // )
        );
  }

  void _addMarkers() {
    int i = 0;
    // var markerIdVal = MyWayToGenerateId();
    final MarkerId markerId = MarkerId("marker_$i");
    i++;

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(structureIndividual.first.latitude,
          structureIndividual.first.longitude),
      infoWindow: InfoWindow(
          title: structureIndividual.first.structure_name, snippet: ''),
    );
    print(
        "Latitude: ${structureIndividual.first.latitude}, Longitude: ${structureIndividual.first.longitude}");

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }
}