import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class GeolocationProvider with ChangeNotifier {
  LocationData? _currentLocation;
  bool _liveUpdate = false;
  bool _perms = false;
  Location _locationService = Location();
  final interactiveFlags = InteractiveFlag.all;
  bool isActive = false;

  get liveUpdate => _liveUpdate;

  get currentLocation => _currentLocation;

  void stopLocationService() {
    print('SERVICIO DE LOCALIZACIÓN PARADO');
    _locationService = Location();
  }

  void startLocationService(MapController controller) async {
    print('SE INICIA EL SERVICIO DE LOCALIZACION');
    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        print('SE PIDEN PERMISOS');
        var perms = await _locationService.requestPermission();
        _perms = perms == PermissionStatus.granted;

        if (_perms) {
          print('SE TIENEN PERMISOS');
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged.listen((LocationData value) async {
            print(
                'SE ACTUALIZA LA POSICION ACTUAL DE '
                    '\n(LAT: ${_currentLocation!.latitude} LONG: ${_currentLocation!.longitude}) A '
                    '\n (LAT: ${location!.latitude} LONG: ${location.longitude}) ');
            _currentLocation = location;

            if (_liveUpdate) {
              controller.move(
                  LatLng(_currentLocation!.latitude!,
                      _currentLocation!.longitude!),
                  controller.zoom);
            }
            notifyListeners();
          });
        } else {
          serviceRequestResult = await _locationService.requestService();
          if (serviceRequestResult) {
            startLocationService(controller);
            return;
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
