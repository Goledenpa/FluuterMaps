import 'package:flutter/material.dart';
import 'package:open_maps_flutter/Providers/providers.dart';
import 'package:provider/provider.dart';

import 'Screens/screens.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MarkerProvider()),
        ChangeNotifierProvider(create: (_) => FormProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo
          )
        ),
        routes: {
          HomeScreen.route: (_) => const HomeScreen(),
          DetailsScreen.route: (_) => const DetailsScreen(),
        },
        initialRoute: "home",
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
