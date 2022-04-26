import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_maps_flutter/Providers/providers.dart';
import '../Model/models.dart';

class MarkerProvider with ChangeNotifier {
  List<MarkerMap> markerList = [];
  final MapController controller = MapController();

  Future<List<Marker>> getMarkersOnMap() async {
    await getListaMarkers();
    return markerList
        .map((point) =>
        Marker(
            point: LatLng(point.latitude, point.longitude),
            width: 60,
            height: 60,
            anchorPos: AnchorPos.align(AnchorAlign.center),
            builder: (context) => const Icon(Icons.pin_drop, size: 60,)
        )).toList();
  }

  Future<List<MarkerMap>> getListaMarkers() async {
    markerList = await DBProvider.db.getMarkers();
    return markerList;
  }

  void moveMap(LatLng value){
    controller.move(value, 8);
  }

  void addToLista(MarkerMap value) {
    markerList.add(value);
    DBProvider.db.addMarkerDB(
        MarkerMap(
            title: value.title,
            description: value.description,
            latitude: value.latitude,
            longitude: value.longitude));
    notifyListeners();
  }

  void removeMarker(MarkerMap value) {
    markerList.remove(value);
    DBProvider.db.removeMarkerDB(value);
    notifyListeners();
  }

  MarkerMap getMarker(LatLng point) {
    return markerList.where((x) => x.latitude == point.latitude && x.longitude == point.longitude)
        .first;
  }

  Future<List<MarkerMap>> getMarkersSearch(String query) async {
    return markerList.where((x) => x.title.contains(query)).toList();
  }
}