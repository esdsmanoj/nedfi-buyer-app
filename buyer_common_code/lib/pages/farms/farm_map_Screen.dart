// import 'package:buyer_common_code/app_imports.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart' as mp;
// import 'package:latlong2/latlong.dart';
//
// class FarmMapScreen extends StatefulWidget {
//   String type;
//
//   FarmMapScreen(this.type, {super.key});
//
//   @override
//   MapSampleState createState() => MapSampleState();
// }
//
// class MapSampleState extends State<FarmMapScreen> {
//   final Completer<mp.GoogleMapController> _controller = Completer<mp.GoogleMapController>();
//   Map<mp.PolygonId, mp.Polygon> polygons = <mp.PolygonId, mp.Polygon>{};
//   num areas = 0;
//   Map<mp.MarkerId, mp.Marker> markers = <mp.MarkerId, mp.Marker>{};
//   mp.MarkerId? selectedMarker;
//   int _markerIdCounter = 1;
//   mp.LatLng? markerPosition;
//   mp.CameraPosition _kGooglePlex = mp.CameraPosition(
//     target: mp.LatLng(double.parse(HeaderSingleton().lat), double.parse((HeaderSingleton().lng))),
//     zoom: 19,
//   );
//
//   mp.CameraPosition kLake = const mp.CameraPosition(bearing: 192.8334901395799, target: mp.LatLng(37.43296265331129, -122.08832357078792), tilt: 59.440717697143555, zoom: 19.151926040649414);
//   Map<mp.PolygonId, double> polygonOffsets = <mp.PolygonId, double>{};
//   int _polygonIdCounter = 0;
//   mp.PolygonId? selectedPolygon;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.type == "EDIT") {
//       if (farmAreaCoordinates != null) {
//         try {
//           Map<String, dynamic> newvar = json.decode(farmAreaCoordinates);
//           Map<String, dynamic> newvars = json.decode(newvar["coordinates"].toString());
//           List<dynamic> coordinates = newvars["coordinates"];
//           for (var element in coordinates) {
//             _addMarker(element[0], element[1]);
//           }
//         } catch (e) {
//           try {
//             List<dynamic> coordinates = [];
//             final details = json.decode(farmAreaCoordinates);
//             if (details is Map<String, dynamic>) {
//               coordinates = details['coordinates'];
//             } else {
//               Map<String, dynamic> newvar = json.decode(json.decode(farmAreaCoordinates));
//               coordinates = newvar["coordinates"];
//             }
//             for (var element in coordinates) {
//               _addMarker(element[0], element[1]);
//             }
//           } catch (e) {
//             List<dynamic> coordinates = [];
//             dynamic newvar = farmAreaCoordinates;
//             coordinates = newvar;
//             for (var element in coordinates) {
//               _addMarker(element[0], element[1]);
//             }
//           }
//         }
//       }
//       //_addMarker();
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void _onPolygonTapped(mp.PolygonId polygonId) {
//     setState(() {
//       selectedPolygon = polygonId;
//     });
//   }
//
//   void _add() {
//     final int polygonCount = polygons.length;
//     if (polygonCount == 12) {
//       return;
//     }
//     const String polygonIdVal = 'polygon_id_11';
//     const mp.PolygonId polygonId = mp.PolygonId(polygonIdVal);
//
//     final mp.Polygon polygon = mp.Polygon(
//       polygonId: polygonId,
//       consumeTapEvents: true,
//       strokeColor: Colors.orange,
//       strokeWidth: 2,
//       fillColor: Colors.green.shade300,
//       points: _createPoints(),
//       onTap: () {
//         _onPolygonTapped(polygonId);
//       },
//     );
//
//     if (farmAreaCoordinates != null) {
//       Tuple2<String, String> points = centroid(polygon.points);
//       _kGooglePlex = mp.CameraPosition(target: mp.LatLng(double.parse(points.item1), double.parse((points.item2))), zoom: 19);
//     }
//
//     setState(() {
//       polygons[polygonId] = polygon;
//       polygonOffsets[polygonId] = _polygonIdCounter.ceilToDouble();
//       _polygonIdCounter++;
//       calculate();
//     });
//   }
//
//   centroid(List<mp.LatLng> points) {
//     dynamic coordinate1 = 0.0;
//     dynamic coordinate2 = 0.0;
//     for (int i = 0; i < points.length; i++) {
//       coordinate1 += points[i].latitude;
//       coordinate2 += points[i].longitude;
//     }
//     int totalPoints = points.length;
//     coordinate1 = coordinate1 / totalPoints;
//     coordinate2 = coordinate2 / totalPoints;
//     return Tuple2<String, String>(coordinate1.toString(), coordinate2.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: WidgetUtils.appTextWidget(context: context, title: 'Add Farms'.tr, color: Colors.white, fontSize: 18),
//       ),
//       body: Stack(children: [
//         mp.GoogleMap(
//           tiltGesturesEnabled: false,
//           mapType: mp.MapType.hybrid,
//           initialCameraPosition: _kGooglePlex,
//           onMapCreated: (mp.GoogleMapController controller) {
//             _controller.complete(controller);
//           },
//           onTap: (latLng) {
//             _addMarker(latLng.latitude, latLng.longitude);
//           },
//           polygons: Set<mp.Polygon>.of(polygons.values),
//           markers: Set<mp.Marker>.of(markers.values),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               width: 200,
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Text("The area is:".tr + " ${(((areaValue / 10000)).toStringAsFixed(3))} " + "hector".tr),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10.0),
//               child: FloatingActionButton.extended(
//                 label: Text('Clear All'.tr, style:  TextStyle(color: Color(int.parse(themeColor.value.buttonTextColor!.color!)))),
//                 backgroundColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
//                 onPressed: () {
//                   // _add();
//                   polygons = <mp.PolygonId, mp.Polygon>{};
//                   markers = <mp.MarkerId, mp.Marker>{};
//                   farmAreaCoordinates = null;
//                   setState(() {});
//                 },
//               ),
//             ),
//           ],
//         ),
//       ]),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 20.0, right: 60),
//         child: FloatingActionButton.extended(
//           label: Text('Submit'.tr, style:  TextStyle(color: Color(int.parse(themeColor.value.buttonTextColor!.color!)))),
//           backgroundColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
//           onPressed: () {
//             const String polygonIdVal = 'polygon_id_11';
//             const mp.PolygonId polygonId = mp.PolygonId(polygonIdVal);
//             if (polygons[polygonId]!.points.length >= 4) {
//               Navigator.pop(context, Tuple2<dynamic, dynamic>(areaValue, farmAreaCoordinates));
//             } else {
//               WidgetUtils.errorDialog(context, 'Please Select Farm co-ordinates'.tr);
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   List<mp.LatLng> _createPoints() {
//     final List<mp.LatLng> points = <mp.LatLng>[];
//     // final double offset = _polygonIdCounter.ceilToDouble();
//     markers.forEach((key, value) {
//       points.add(_createLatLng(value.position.latitude /*+offset*/, value.position.longitude));
//     });
//     return points;
//   }
//
//   mp.LatLng _createLatLng(double lat, double lng) {
//     return mp.LatLng(lat, lng);
//   }
//
//   void calculate() {
//     List<List<double>> coordinates = [];
//     List<LatLngs> latLongList = [];
//     const String polygonIdVal = 'polygon_id_11';
//     const mp.PolygonId polygonId = mp.PolygonId(polygonIdVal);
//     for (var element in polygons[polygonId]!.points) {
//       coordinates.add([element.latitude, element.longitude]);
//       latLongList.add(LatLngs(element.latitude, element.longitude));
//     }
//
//     // var farmAreaCoordi = {
//     //   'type': 'Polygon',
//     //   'coordinates': [coordinates]
//     // };
//     farmAreaCoordinates = coordinates;
//     var areaInSquareMeters = computeArea(latLongList);
//     areas = areaInSquareMeters;
//     areaValue = areaInSquareMeters;
//   }
//
//   void _onMarkerTapped(mp.MarkerId markerId) {
//     final mp.Marker? tappedMarker = markers[markerId];
//     if (tappedMarker != null) {
//       setState(() {
//         final mp.MarkerId? previousMarkerId = selectedMarker;
//         if (previousMarkerId != null && markers.containsKey(previousMarkerId)) {
//           final mp.Marker resetOld = markers[previousMarkerId]!.copyWith(iconParam: mp.BitmapDescriptor.defaultMarker);
//           markers[previousMarkerId] = resetOld;
//         }
//         selectedMarker = markerId;
//         final mp.Marker newMarker = tappedMarker.copyWith(
//           iconParam: mp.BitmapDescriptor.defaultMarkerWithHue(
//             mp.BitmapDescriptor.hueGreen,
//           ),
//         );
//         markers[markerId] = newMarker;
//         markerPosition = null;
//       });
//     }
//   }
//
//   void _addMarker(double lat, double log) {
//     mp.LatLng center = mp.LatLng(lat, log);
//     final int markerCount = markers.length;
//
//     if (markerCount == 12) {
//       return;
//     }
//
//     final String markerIdVal = 'marker_id_$_markerIdCounter';
//     _markerIdCounter++;
//     final mp.MarkerId markerId = mp.MarkerId(markerIdVal);
//
//     final mp.Marker marker = mp.Marker(
//       markerId: markerId,
//       draggable: true,
//       position: mp.LatLng(center.latitude, center.longitude),
//       infoWindow: mp.InfoWindow(title: markerIdVal, snippet: '*'),
//       onTap: () => _onMarkerTapped(markerId),
//       onDragEnd: (mp.LatLng position) => _onMarkerDragEnd(markerId, position),
//       onDrag: (mp.LatLng position) => _onMarkerDrag(markerId, position),
//     );
//
//     setState(() {
//       markers[markerId] = marker;
//       _add();
//     });
//   }
//
//   Future<void> _onMarkerDrag(mp.MarkerId markerId, mp.LatLng newPosition) async {
//     setState(() {
//       markerPosition = newPosition;
//     });
//   }
//
//   Future<void> _onMarkerDragEnd(mp.MarkerId markerId, mp.LatLng newPosition) async {
//     final mp.Marker? tappedMarker = markers[markerId];
//     mp.Marker? marker = markers[markerId];
//     if (tappedMarker != null) {
//       setState(() {
//         markers[markerId] = marker!.copyWith(positionParam: mp.LatLng(newPosition.latitude, newPosition.longitude));
//         markerPosition = null;
//         _add();
//       });
//       /* await showDialog<void>(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//                 actions: <Widget>[
//                   TextButton(
//                     child: const Text('OK'),
//                     onPressed: () => Navigator.of(context).pop(),
//                   )
//                 ],
//                 content: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 66),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Text('Old position: ${tappedMarker.position}'),
//                         Text('New position: $newPosition'),
//                       ],
//                     )));
//           });*/
//     }
//   }
//
//   static num computeArea(List<LatLngs> path) => computeSignedArea(path).abs();
//
//   /// Returns the signed area of a closed path on Earth. The sign of the area
//   /// may be used to determine the orientation of the path.
//   /// "inside" is the surface that does not contain the South Pole.
//   /// @param path A closed path.
//   /// @return The loop's area in square meters.
//   static num computeSignedArea(List<LatLngs> path) => _computeSignedArea(path, earthRadius);
//
//   /// Returns the signed area of a closed path on a sphere of given radius.
//   /// The computed area uses the same units as the radius squared.
//   /// Used by SphericalUtilTest.
//   static num _computeSignedArea(List<LatLngs> path, num radius) {
//     if (path.length < 3) {
//       return 0;
//     }
//
//     final prev = path.last;
//     var prevTanLat = tan((pi / 2 - MathUtil.toRadians(prev.latitude)) / 2);
//     var prevLng = MathUtil.toRadians(prev.longitude);
//
//     // For each edge, accumulate the signed area of the triangle formed by the
//     // North Pole and that edge ("polar triangle").
//     final total = path.fold<num>(0.0, (value, point) {
//       final tanLat = tan((pi / 2 - MathUtil.toRadians(point.latitude)) / 2);
//       final lng = MathUtil.toRadians(point.longitude);
//
//       value += _polarTriangleArea(tanLat, lng, prevTanLat, prevLng);
//
//       prevTanLat = tanLat;
//       prevLng = lng;
//
//       return value;
//     });
//
//     return total * (radius * radius);
//   }
//
//   /// Returns the signed area of a triangle which has North Pole as a vertex.
//   /// Formula derived from "Area of a spherical triangle given two edges and
//   /// the included angle" as per "Spherical Trigonometry" by Todhunter, page 71,
//   /// section 103, point 2.
//   /// See http://books.google.com/books?id=3uBHAAAAIAAJ&pg=PA71
//   /// The arguments named "tan" are tan((pi/2 - latitude)/2).
//   static num _polarTriangleArea(num tan1, num lng1, num tan2, num lng2) {
//     final deltaLng = lng1 - lng2;
//     final t = tan1 * tan2;
//     return 2 * atan2(t * sin(deltaLng), 1 + t * cos(deltaLng));
//   }
// }
