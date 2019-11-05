import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:islington_navigation_flutter/controller/utils/constants.dart';
import 'package:islington_navigation_flutter/model/app/blocks.dart';
import 'package:islington_navigation_flutter/model/app/structures.dart';
import 'package:geolocator/geolocator.dart';
import '../requests/google_map_services.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map(),
    );
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Structures>> key = new GlobalKey();

  static List<Structures> structures = new List<Structures>();
  static List<Blocks> blocks = new List<Blocks>();
  static List<Structures> structureIndividual = new List<Structures>();

  bool empty = true;
  bool blockTilesVisible = true;

  GoogleMapController _mapController;
  GoogleMapsServices googleMapsServices = GoogleMapsServices();

  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStructures();
    _getAllBlocks();
    _getUserLocation();
  }

  //widget for creating google map
  Widget googleMap() {
    return GoogleMap(
      initialCameraPosition:
          // CameraPosition(target: _initialPosition, zoom: 25.0),
          CameraPosition(target: LatLng(27.708426, 85.326022), zoom: 16.0),
      onMapCreated: onCreate,
      myLocationEnabled: true,
      mapType: MapType.normal,
      compassEnabled: true,
      markers: _markers,
      onCameraMove: _onCameraMove,
      polylines: _polylines,
    );
  }

  // widget for creating initial text field
  Widget startingPointTextField() {
    return Positioned(
      top: 50.0,
      right: 15.0,
      left: 15.0,
      child: Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1.0, 5.0),
                blurRadius: 10,
                spreadRadius: 3)
          ],
        ),
        child: TextField(
          cursorColor: Colors.black,
          controller: locationController,
          decoration: InputDecoration(
            icon: Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              width: 10,
              height: 10,
              child: Icon(
                Icons.location_on,
                color: Colors.black,
              ),
            ),
            hintText: "Starting point",
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
          ),
        ),
      ),
    );
  }

  // widget for destination text field with auto complete suggestions
  Widget endingPointTextField() {
    return Positioned(
      top: 105,
      right: 15,
      left: 15,
      child: Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 5.0),
                  blurRadius: 10,
                  spreadRadius: 3)
            ]),
        child: searchTextField = AutoCompleteTextField<Structures>(
          key: key,
          clearOnSubmit: false,
          suggestions: structures,
          style: TextStyle(color: Colors.black, fontSize: 20.0),
          decoration: InputDecoration(
            icon: Container(
                margin: EdgeInsets.only(left: 20.0, top: 5.0),
                width: 10.0,
                height: 10.0,
                child: Icon(Icons.location_on),
                color: Colors.black),
            hintText: "Search Class",
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
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
              blockTilesVisible = false;
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
                    "latitude and longitude are: ${structureIndividual.first.latitude}, ${structureIndividual.first.longitude}");
                LatLng destination = LatLng(structureIndividual.first.latitude,
                    structureIndividual.first.longitude);

                _addMarker(
                    destination,
                    structureIndividual.first.structure_name,
                    structureIndividual.first.block_name);
                // sendRequest(
                //     structureIndividual.first.latitude,
                //     structureIndividual.first.longitude,
                //     structureIndividual.first.structure_name,
                //     );
              });
            });
          },
          itemBuilder: (context, item) {
            // ui for the autocompelete row
            return row(item);
          },
        ),
      ),
    );
  }

  // widget for creating bottom tiles for blocks
  Widget blockBottomInfoTile() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        height: 150.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: blocks.length,
          itemBuilder: (BuildContext context, int index) {
            return boxes(
                blocks[index].image,
                blocks[index].latitude,
                blocks[index].longitude,
                blocks[index].block_name,
                blocks[index].block_name);
          },
        ),
      ),
    );
  }

  // widget for creating bottom tiles for blocks
  Widget structureBottomInfoTile() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        height: 150.0,
        child: boxes(
            structureIndividual.first.images,
            structureIndividual.first.latitude,
            structureIndividual.first.longitude,
            structureIndividual.first.structure_name,
            structureIndividual.first.floor +
                " Floor of " +
                structureIndividual.first.block_name),
      ),
    );
  }

  // widget for creating boxes for bottom tiles of all the blocks and structures
  Widget boxes(String image, double latitude, double longitude, String name,
      String detail) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(latitude, longitude);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Container(
          child: FittedBox(
            child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24),
              shadowColor: Colors.black38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image(
                        fit: BoxFit.fill,
                        image: blockTilesVisible == true
                            ? NetworkImage(GET_BLOCK_IMAGES + image)
                            : NetworkImage(GET_STRUCTURE_IMAGES + image),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(name,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 30.0)),
                          Text(detail,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 25.0)),
                          IconButton(
                            color: Colors.black,
                            icon: Icon(
                              Icons.directions,
                              size: 35.0,
                            ),
                            onPressed: () {
                              sendRequest(
                                latitude,
                                longitude,
                                name,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // widget for showing auto suggestion in destination text field
  Widget row(Structures structures) {
    return Card(
      child: SingleChildScrollView(
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
    return _initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: <Widget>[
              googleMap(),
              startingPointTextField(),
              endingPointTextField(),
              blockTilesVisible == true
                  ? blockBottomInfoTile()
                  : structureIndividual != null
                      ? structureBottomInfoTile()
                      : SizedBox(),
            ],
          );
  }

  Future<void> _gotoLocation(double lat, double lng) async {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lat, lng), zoom: 19, tilt: 50, bearing: 45.0)),
    );
  }

  void _getStructures() async {
    fetchAllStructures(http.Client()).then((value) {
      setState(() {
        structures = value;
        print(structures.first.structure_name);
        // loading = false;
      });
    });
  }

  void _getAllBlocks() async {
    fetchAllBlocks(http.Client()).then((value) {
      setState(() {
        blocks = value;
        print(blocks.length);
        print("Block: " + blocks.toString());
        print("Latitude: " +
            blocks.first.latitude.toString() +
            "," +
            "Longitude: " +
            blocks.first.longitude.toString() +
            "," +
            "Block Name: " +
            blocks.first.block_name);

        for (var block in blocks) {
          _markers.add(
            Marker(
              markerId: MarkerId(block.block_id.toString()),
              position: LatLng(block.latitude, block.longitude),
              // onTap: showBottomsheet,
              infoWindow: InfoWindow(
                title: block.block_name,
                snippet: block.block_name,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            ),
          );
        }
      });
    });
  }

  void showBottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return FittedBox(
            child: Material(
              color: Colors.white,
              elevation: 15.0,
              borderRadius: BorderRadius.circular(25.0),
              shadowColor: Color(0x802196F3),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Text(structureIndividual.first.structure_name,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.0)),
                          Text(
                              structureIndividual.first.floor +
                                  " Floor of " +
                                  structureIndividual.first.block_name,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 15.0)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 250,
                    height: 180,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(25.0),
                      child: Image(
                        fit: BoxFit.fill,
                        alignment: Alignment.topRight,
                        image: NetworkImage(
                          GET_STRUCTURE_IMAGES +
                              structureIndividual.first.images,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void onCreate(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _addMarker(LatLng location, String address, String block) {
    _markers.clear();
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId(_lastPosition.toString()),
            position: location,
            // onTap: showBottomsheet,
            infoWindow: InfoWindow(title: address, snippet: block),
            icon: BitmapDescriptor.defaultMarker),
      );
    });
  }

  void createRoute(String encodedPolyline) {
    _polylines.clear();
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 25,
        points: convertToLatLng(decodePoly(encodedPolyline)),
        color: Colors.blue,
        onTap: () {},
      ));
    });
  }

  // this funtion will convert list of doubles into latlang
  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      locationController.text = placemark[0].name;
    });
  }

  void sendRequest(double latitude, double longitude, String location) async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 13.0)));
    LatLng destination = LatLng(latitude, longitude);
    String route = await googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
  }
}
