import 'package:flutter/material.dart';
import 'package:google_maps_alternative_directions/src/services/api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

class ProviderMaps with ChangeNotifier {
  LatLng _initialposition = LatLng(-12.122711, -77.027475);
  late LatLng _finalposition;
  late GoogleMapController _mapController;
  LatLng get initialPos => _initialposition;
  LatLng get finalPos => _finalposition;
  final Set<Marker> _markers = Set();
  final Set<Polyline> _polylines = Set();
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyline => _polylines;
  String distance = "";
  GoogleMapController get mapController => _mapController;
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  String calculatedistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double res = 12742 * asin(sqrt(a));
    if (res.toString().substring(0, 1) == "0") {
      res = (12742 * asin(sqrt(a))) * 1000;
      return res.toStringAsFixed(2) + " m";
    } else {
      res = res;
      return res.toStringAsFixed(2) + " Km";
    }
  }

  void addMarker(LatLng location) {
    if (markers.length < 2) {
      _markers.add(Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          icon: BitmapDescriptor.defaultMarker));
    }
    notifyListeners();
  }

  void routermap() async {
    polyline.clear();
    for (int i = 0; i < markers.length; i++) {
      if (i == 0) {
        _initialposition = markers.elementAt(i).position;
      }
      if (i == 1) {
        _finalposition = markers.elementAt(i).position;
      }
    }
    List<LatLng>? polylines = await ApiOSRM().getpoints(
        _initialposition.longitude.toString(),
        _initialposition.latitude.toString(),
        _finalposition.longitude.toString(),
        _finalposition.latitude.toString());
    createpolyline(polylines!);
    distance = calculatedistance(
        _initialposition.latitude,
        _initialposition.longitude,
        _finalposition.latitude,
        _finalposition.longitude);
    notifyListeners();
  }

  void createpolyline(List<LatLng> polylines) {
    _polylines.add(Polyline(
        polylineId: PolylineId(_initialposition.toString()),
        width: 5,
        points: polylines,
        color: Colors.redAccent));
    notifyListeners();
  }

  void cleanpoint(int index) {
    polyline.clear();
    distance = '';
    markers.remove(markers.elementAt(index));
  }
}
