import 'package:flutter/material.dart';


class FormProvider with ChangeNotifier{
  GlobalKey<FormState> key = GlobalKey<FormState>();

  String? title;
  String? description;
  String? latitude;
  String? longitude;

  clear(){
    title = null;
    description = null;
    latitude = null;
    longitude = null;
  }
}