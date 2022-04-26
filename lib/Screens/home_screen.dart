import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_maps_flutter/Screens/details_screen.dart';
import 'package:provider/provider.dart';
import '../Providers/providers.dart';
import '../Widget/search_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String route = "home";

  @override
  Widget build(BuildContext context) {
    MarkerProvider provider =
        Provider.of<MarkerProvider>(context, listen: true);
    final PopupController _popupController = PopupController();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mapa"),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: MapSearchDelegate());
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: FutureBuilder(
            future: provider.getMarkersOnMap(),
            builder: (context, AsyncSnapshot markerList) {
              return Stack(children: [
                FlutterMap(
                  mapController: provider.controller,
                  options: MapOptions(
                    plugins: [MarkerClusterPlugin()],
                    center: LatLng(40.463667, -3.74922),
                    maxZoom: 18,
                    zoom: 4,
                    onTap: (_, __) => _popupController.hideAllPopups(),
                    onLongPress: (_, latlng) => Navigator.of(context)
                        .pushNamed(DetailsScreen.route, arguments: latlng),
                  ),
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {},
                      child: const Icon(Icons.home),
                    )
                  ],
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c']),
                    MarkerClusterLayerOptions(
                      spiderfyCircleRadius: 80,
                      spiderfySpiralDistanceMultiplier: 2,
                      circleSpiralSwitchover: 12,
                      maxClusterRadius: 120,
                      rotate: true,
                      size: const Size(40, 40),
                      anchor: AnchorPos.align(AnchorAlign.center),
                      fitBoundsOptions: const FitBoundsOptions(
                        padding: EdgeInsets.all(50),
                        maxZoom: 15,
                      ),
                      markers: markerList.data ?? [],
                      polygonOptions: const PolygonOptions(
                          borderColor: Colors.indigo,
                          color: Colors.black12,
                          borderStrokeWidth: 3),
                      popupOptions: PopupOptions(
                          popupSnap: PopupSnap.markerTop,
                          popupController: _popupController,
                          popupBuilder: (_, marker) => Container(
                                width: 200,
                                height: 100,
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () => debugPrint('Popup tap!'),
                                  child: Text(
                                    provider
                                        .getMarker(marker.point)
                                        .description,
                                  ),
                                ),
                              )),
                      builder: (context, markers) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.indigo),
                          child: Center(
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                FloatingActionButton(elevation: 100,
                    onPressed: () {}, child: const Icon(Icons.home))
              ]);
            }));
  }
}
