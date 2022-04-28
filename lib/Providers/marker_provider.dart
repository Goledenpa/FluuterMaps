import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../Model/models.dart';
import 'providers.dart';

class MarkerProvider with ChangeNotifier {
  List<MarkerMap> markerList = [];
  final MapController controller = MapController();

  Future<List<Marker>> getMarkersOnMap() async {
    print('TAMAÑO: ${markerList.length}');
    return markerList
        .map((point) =>
        Marker(
            point: LatLng(point.latitude, point.longitude),
            width: 60,
            height: 60,
            anchorPos: AnchorPos.align(AnchorAlign.center),
            builder: (context) =>
            Icon(
              Icons.pin_drop,
              color: (point.id != null && point.id == -1) ? Colors.red : Colors.black,
              size: 60,
            )))
        .toList();
  }

  Future<List<MarkerMap>> getListaMarkers() async {
    markerList = await DBProvider.db.getMarkers();
    return markerList;
  }

  void moveMap(LatLng value) {
    controller.move(value, 12);
  }

  void addToLista(MarkerMap value) {
    markerList.add(value);
    if (value.id == null) {
      DBProvider.db.addMarkerDB(MarkerMap(
          title: value.title,
          description: value.description,
          latitude: value.latitude,
          longitude: value.longitude));
    }

    notifyListeners();
  }

  void removeMarker(MarkerMap value) {
    markerList.remove(value);
    DBProvider.db.removeMarkerDB(value);
    notifyListeners();
  }

  MarkerMap getMarker(LatLng point) {
    return markerList
        .where((x) =>
    x.latitude == point.latitude && x.longitude == point.longitude)
        .first;
  }

  Future<List<MarkerMap>> getMarkersSearch(String query) async {
    return markerList.where((x) => x.title.contains(query)).toList();
  }

  void setCurrentLocation(LocationData? value)
  {
    print('SET CURRENT LOC');
    if(value == null){
      markerList.add(MarkerMap(
          id: -1,
          title: 'Posicion Actual',
          description: 'Mi posicion',
          latitude: 0,
          longitude: 0));
      return;
    }
    print('No es nulo :D fernando cartulina');
    markerList.add(MarkerMap(
        id: -1,
        title: 'Posicion Actual',
        description: 'Mi posicion',
        latitude: value.latitude!,
        longitude: value.longitude!));
  }
}
