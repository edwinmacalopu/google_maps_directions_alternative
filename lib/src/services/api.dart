import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
class ApiOSRM{
  Future<List<LatLng>> getpoints(String longini,String latini,String longend,String latend)async{
     List<LatLng> llena=[];
    var url="http://router.project-osrm.org/route/v1/driving/$longini,$latini;$longend,$latend?geometries=geojson";
    var response= await http.get(url);
    if(response.statusCode==200){
      var rutar=jsonDecode(response.body)["routes"][0]["geometry"]["coordinates"];
       for(int i=0;i<rutar.length;i++){
            var reep=rutar[i].toString();
            reep=reep.replaceAll("[", "");
            reep= reep.replaceAll("]", ""); 
            var lat1=reep.split(',');
            var long1=reep.split(',');           
            llena.add(LatLng(double.parse(lat1[1]),double.parse(long1[0])));
            }
            return llena;
    }else{
      return null;
    }
  }
}