import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_maps_flutter/Providers/form_detail_provider.dart';
import 'package:open_maps_flutter/Providers/marker_provider.dart';
import 'package:provider/provider.dart';
import '../Model/models.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);
  static const String route = "details";

  @override
  Widget build(BuildContext context) {
    FormProvider provider = Provider.of<FormProvider>(context, listen: true);
    MarkerProvider providerMarker =
        Provider.of<MarkerProvider>(context, listen: false);
    final LatLng latLng = ModalRoute.of(context)?.settings.arguments as LatLng;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir marcador"),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: provider.key,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                initialValue: provider.title,
                onChanged: (value) => provider.title = value,
                validator: (value) =>
                    value?.length == 0 ? 'Es necesario dar un título' : null,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Titulo',
                    labelStyle: TextStyle(fontSize: 16)),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                initialValue: provider.description,
                onChanged: (value) => provider.description = value,
                validator: (value) => value?.length == 0
                    ? 'Es necesario dar una descripción'
                    : null,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Descripcion',
                    labelStyle: TextStyle(fontSize: 16)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      enabled: false,
                      initialValue: provider.latitude =
                          latLng.latitude.toStringAsFixed(4),
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Latitud',
                          labelStyle: TextStyle(fontSize: 16)),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      enabled: false,
                      initialValue: provider.longitude =
                          latLng.longitude.toStringAsFixed(4),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Longitud',
                        labelStyle: TextStyle(fontSize: 16),
                      ),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.indigo),
                        onPressed: () {
                          if (provider.key.currentState!.validate()) {
                            try {
                              providerMarker.addToLista(MarkerMap(
                                  title: provider.title!,
                                  description: provider.description!,
                                  latitude: double.tryParse(provider.latitude!)!,
                                  longitude:double.tryParse(provider.longitude!)!
                              ));
                              provider.clear();
                              Navigator.pop(context);
                            } catch (e, s) {
                              print(s);
                            }
                          }
                        },
                        child: const Text(
                          "Aceptar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.grey),
                        onPressed: () => {Navigator.pop(context)},
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
