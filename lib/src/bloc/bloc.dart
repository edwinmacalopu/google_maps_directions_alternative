import 'package:flutter/material.dart';
import 'package:google_maps_alternative_directions/src/services/api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderMaps with ChangeNotifier{
 LatLng _initialposition=LatLng(-12.122711,-77.027475);
 LatLng _finalposition;
 GoogleMapController _mapController;
LatLng get initialPos =>_initialposition;
LatLng get finalPos =>_finalposition;
final Set<Marker> _markers=Set();
final Set<Polyline> _polylines=Set();
Set<Marker> get markers => _markers;
Set<Polyline> get polyline => _polylines;
GoogleMapController get mapController => _mapController;
  void onCreated(GoogleMapController controller) {
    _mapController = controller;  
    notifyListeners();
  }
  void addMarker(LatLng location) {
    if(markers.length<2){
        _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,        
        icon: BitmapDescriptor.defaultMarker));      
     }
       notifyListeners();
  }
  void routermap()async{    
    polyline.clear();
     for(int i=0;i<markers.length;i++){
        if(i==0){
        _initialposition=markers.elementAt(i).position;
          }
        if(i==1){
        _finalposition=markers.elementAt(i).position;
        }
     }
     List<LatLng> polylines=await ApiOSRM().getpoints(_initialposition.longitude.toString(),_initialposition.latitude.toString(),
      _finalposition.longitude.toString(),_finalposition.latitude.toString());
    createpolyline(polylines);
  }
  void createpolyline(List<LatLng> polylines){
    _polylines.add(Polyline(
        polylineId: PolylineId(_initialposition.toString()),
        width: 5,
        points: polylines,
        color: Colors.redAccent));
    notifyListeners();
  }
}